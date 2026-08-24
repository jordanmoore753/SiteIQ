class CaptureJob < ApplicationJob
  queue_as :default

  LCP_OBSERVER_JS = <<~JS
    const po = new PerformanceObserver((list) => {
      const entries = list.getEntries()
      arguments[0](entries[entries.length - 1].startTime)
    })
    po.observe({ type: "largest-contentful-paint", buffered: true })
    setTimeout(() => arguments[0](null), 4000)
  JS

  private_constant :LCP_OBSERVER_JS

  # Loads a URL in a headless browser and measures TTFB, LCP, subresource
  # error counts, and total page size.
  #
  # @param url [String] the URL to load and measure
  # @return [Hash] :ttfb, :lcp, :count_404, :count_500, and :total_size_mb
  def perform(url)
    browser = Ferrum::Browser.new
    navigate(browser, url)

    ttfb = measure_ttfb(browser)
    lcp = measure_lcp(browser)
    responses = fetch_responses(browser)
    statuses = responses.map(&:status)
    total_size_mb = (responses.sum { |response| [ response.body_size || 0, 0 ].max } / 1024.0 / 1024.0).round(2)

    {
      ttfb: ttfb,
      lcp: lcp,
      count_404: statuses.count(404),
      count_500: statuses.count(500),
      total_size_mb: total_size_mb,
    }
  ensure
    browser&.quit
  end

  private

  # Navigates the browser to the given URL.
  #
  # @param browser [Ferrum::Browser]
  # @param url [String] the URL to load
  # @return [void]
  def navigate(browser, url)
    browser.goto(url)
  end

  # Reads Time to First Byte from the Navigation Timing API.
  #
  # @param browser [Ferrum::Browser]
  # @return [Float] TTFB in milliseconds
  def measure_ttfb(browser)
    browser.evaluate("performance.getEntriesByType('navigation')[0].responseStart")
  end

  # Reads Largest Contentful Paint via a PerformanceObserver, since LCP
  # entries aren't available through getEntriesByType without one.
  #
  # @param browser [Ferrum::Browser]
  # @return [Float, nil] LCP in milliseconds, or nil if no entry was
  #   reported before the internal timeout
  def measure_lcp(browser)
    browser.evaluate_async(LCP_OBSERVER_JS, 5)
  end

  # Fetches every network response the page triggered while loading.
  #
  # @param browser [Ferrum::Browser]
  # @return [Array<Ferrum::Network::Response>]
  def fetch_responses(browser)
    browser.network.traffic.filter_map(&:response)
  end
end
