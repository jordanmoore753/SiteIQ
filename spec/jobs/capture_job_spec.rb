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
      .with(kind_of(String), 5)
      .and_return(268)
    allow(browser).to receive(:network).and_return(network)
    allow(network).to receive(:traffic).and_return([ ok, not_found, not_found, server_error, cached ])

    result = CaptureJob.perform_now("https://www.jordanmoore.dev/")

    expect(result).to eq(ttfb: 132.2, lcp: 268, count_404: 2, count_500: 1, total_size_mb: 0.02)
    expect(browser).to have_received(:goto).with("https://www.jordanmoore.dev/")
    expect(browser).to have_received(:quit)
  end

  context "when a network response never finishes loading and has no body_size" do
    it "treats it as contributing 0 bytes instead of raising" do
      browser = instance_double(Ferrum::Browser, goto: true, quit: true)
      network = instance_double(Ferrum::Network)
      unfinished = instance_double(Ferrum::Network::Exchange, response: instance_double(Ferrum::Network::Response, status: 200, body_size: nil))
      allow(Ferrum::Browser).to receive(:new).and_return(browser)
      allow(browser).to receive(:evaluate)
        .with("performance.getEntriesByType('navigation')[0].responseStart")
        .and_return(100)
      allow(browser).to receive(:evaluate_async)
        .with(kind_of(String), 5)
        .and_return(200)
      allow(browser).to receive(:network).and_return(network)
      allow(network).to receive(:traffic).and_return([ unfinished ])

      result = CaptureJob.perform_now("https://www.jordanmoore.dev/")

      expect(result[:total_size_mb]).to eq(0.0)
    end
  end
end
