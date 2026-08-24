require "rails_helper"

RSpec.describe CaptureJob do
  it "returns the TTFB reported by the browser and quits it" do
    browser = instance_double(Ferrum::Browser, goto: true, quit: true)
    allow(Ferrum::Browser).to receive(:new).and_return(browser)
    allow(browser).to receive(:evaluate)
      .with("performance.getEntriesByType('navigation')[0].responseStart")
      .and_return(132.2)

    result = CaptureJob.perform_now("https://www.jordanmoore.dev/")

    expect(result).to eq(132.2)
    expect(browser).to have_received(:goto).with("https://www.jordanmoore.dev/")
    expect(browser).to have_received(:quit)
  end
end
