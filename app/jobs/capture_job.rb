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

  TTFB_OK_MS = 800
  LCP_OK_MS = 2500
  PAGE_SIZE_OK_MB = 1.5
  ERROR_COUNT_OK = 0

  private_constant :TTFB_OK_MS, :LCP_OK_MS, :PAGE_SIZE_OK_MB, :ERROR_COUNT_OK

  def perform(url)
    browser = Ferrum::Browser.new
    browser.goto(url)

    ttfb = browser.evaluate("performance.getEntriesByType('navigation')[0].responseStart")
    lcp = browser.evaluate_async(LCP_OBSERVER_JS, 5)
    responses = browser.network.traffic.filter_map(&:response)
    statuses = responses.map(&:status)
    total_size_mb = (responses.sum { |response| [ response.body_size, 0 ].max } / 1024.0 / 1024.0).round(2)
    count_404 = statuses.count(404)
    count_500 = statuses.count(500)

    {
      ttfb: { value: ttfb, ok: ttfb <= TTFB_OK_MS },
      lcp: { value: lcp, ok: lcp.nil? || lcp <= LCP_OK_MS },
      count_404: { value: count_404, ok: count_404 <= ERROR_COUNT_OK },
      count_500: { value: count_500, ok: count_500 <= ERROR_COUNT_OK },
      total_size_mb: { value: total_size_mb, ok: total_size_mb <= PAGE_SIZE_OK_MB },
    }
  ensure
    browser&.quit
  end
end
