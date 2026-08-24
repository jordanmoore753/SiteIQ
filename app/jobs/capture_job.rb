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

  def perform(url)
    browser = Ferrum::Browser.new
    browser.goto(url)

    ttfb = browser.evaluate("performance.getEntriesByType('navigation')[0].responseStart")
    lcp = browser.evaluate_async(LCP_OBSERVER_JS, 5)
    statuses = browser.network.traffic.filter_map { |exchange| exchange.response&.status }

    { ttfb: ttfb, lcp: lcp, count_404: statuses.count(404), count_500: statuses.count(500) }
  ensure
    browser&.quit
  end
end
