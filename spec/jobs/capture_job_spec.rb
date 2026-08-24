require "rails_helper"

RSpec.describe CaptureJob do
  it "returns the TTFB, LCP, error counts, and total size reported by the browser and quits it" do
    browser = instance_double(Ferrum::Browser, goto: true, quit: true)
    network = instance_double(Ferrum::Network)
    not_found = instance_double(Ferrum::Network::Exchange, response: instance_double(Ferrum::Network::Response, status: 404, body_size: 500))
    server_error = instance_double(Ferrum::Network::Exchange, response: instance_double(Ferrum::Network::Response, status: 500, body_size: 300))
    ok = instance_double(Ferrum::Network::Exchange, response: instance_double(Ferrum::Network::Response, status: 200, body_size: 24276))
    cached = instance_double(Ferrum::Network::Exchange, response: instance_double(Ferrum::Network::Response, status: 200, body_size: -2076))
    allow(Ferrum::Browser).to receive(:new).and_return(browser)
    allow(browser).to receive(:evaluate)
      .with("performance.getEntriesByType('navigation')[0].responseStart")
      .and_return(132.2)
    allow(browser).to receive(:evaluate_async)
      .with(CaptureJob::LCP_OBSERVER_JS, 5)
      .and_return(268)
    allow(browser).to receive(:network).and_return(network)
    allow(network).to receive(:traffic).and_return([ ok, not_found, not_found, server_error, cached ])

    result = CaptureJob.perform_now("https://www.jordanmoore.dev/")

    expect(result).to eq(ttfb: 132.2, lcp: 268, count_404: 2, count_500: 1, total_size_mb: 0.02)
    expect(browser).to have_received(:goto).with("https://www.jordanmoore.dev/")
    expect(browser).to have_received(:quit)
  end
end
