class CaptureJob < ApplicationJob
  queue_as :default

  def perform(url)
    browser = Ferrum::Browser.new
    browser.goto(url)
    browser.evaluate("performance.getEntriesByType('navigation')[0].responseStart")
  ensure
    browser&.quit
  end
end
