require "rails_helper"

RSpec.describe Capture do
  it "belongs to a site" do
    site = Site.create!(url: "https://www.jordanmoore.dev/")

    capture = Capture.create!(site: site, ttfb: 81.1, lcp: 264, count_404: 0, count_500: 0, total_size_mb: 0.87)

    expect(capture.site).to eq(site)
  end

  it "is invalid without a site" do
    capture = Capture.new(ttfb: 81.1, lcp: 264, count_404: 0, count_500: 0, total_size_mb: 0.87)

    expect(capture).not_to be_valid
  end

  it "flags every metric as ok when within the acceptable thresholds" do
    site = Site.create!(url: "https://www.jordanmoore.dev/")
    capture = Capture.create!(site: site, ttfb: 800, lcp: 2500, count_404: 0, count_500: 0, total_size_mb: 1.5)

    expect(capture.ttfb_ok?).to eq(true)
    expect(capture.lcp_ok?).to eq(true)
    expect(capture.count_404_ok?).to eq(true)
    expect(capture.count_500_ok?).to eq(true)
    expect(capture.total_size_mb_ok?).to eq(true)
  end

  it "flags every metric as not ok when it exceeds the acceptable thresholds" do
    site = Site.create!(url: "https://www.jordanmoore.dev/")
    capture = Capture.create!(site: site, ttfb: 801, lcp: 2501, count_404: 1, count_500: 1, total_size_mb: 1.51)

    expect(capture.ttfb_ok?).to eq(false)
    expect(capture.lcp_ok?).to eq(false)
    expect(capture.count_404_ok?).to eq(false)
    expect(capture.count_500_ok?).to eq(false)
    expect(capture.total_size_mb_ok?).to eq(false)
  end

  it "treats a nil LCP as ok since no measurement was reported" do
    site = Site.create!(url: "https://www.jordanmoore.dev/")
    capture = Capture.create!(site: site, ttfb: 100, lcp: nil, count_404: 0, count_500: 0, total_size_mb: 0.1)

    expect(capture.lcp_ok?).to eq(true)
  end

  it "serializes to JSON with each metric nested under value and ok" do
    site = Site.create!(url: "https://www.jordanmoore.dev/")
    capture = Capture.create!(site: site, ttfb: 950, lcp: 3000, count_404: 1, count_500: 0, total_size_mb: 2.0)

    expect(capture.as_json).to eq(
      id: capture.id,
      site_id: site.id,
      created_at: capture.created_at,
      updated_at: capture.updated_at,
      ttfb: { value: 950.0, ok: false },
      lcp: { value: 3000.0, ok: false },
      count_404: { value: 1, ok: false },
      count_500: { value: 0, ok: true },
      total_size_mb: { value: 2.0, ok: false },
    )
  end
end
