class Capture < ApplicationRecord
  belongs_to :site

  TTFB_OK_MS = 800
  LCP_OK_MS = 2500
  PAGE_SIZE_OK_MB = 1.5
  ERROR_COUNT_OK = 0

  private_constant :TTFB_OK_MS, :LCP_OK_MS, :PAGE_SIZE_OK_MB, :ERROR_COUNT_OK

  def ttfb_ok?
    ttfb <= TTFB_OK_MS
  end

  def lcp_ok?
    lcp.nil? || lcp <= LCP_OK_MS
  end

  def count_404_ok?
    count_404 <= ERROR_COUNT_OK
  end

  def count_500_ok?
    count_500 <= ERROR_COUNT_OK
  end

  def total_size_mb_ok?
    total_size_mb <= PAGE_SIZE_OK_MB
  end

  def as_json(*)
    {
      id: id,
      site_id: site_id,
      created_at: created_at,
      updated_at: updated_at,
      ttfb: { value: ttfb, ok: ttfb_ok? },
      lcp: { value: lcp, ok: lcp_ok? },
      count_404: { value: count_404, ok: count_404_ok? },
      count_500: { value: count_500, ok: count_500_ok? },
      total_size_mb: { value: total_size_mb, ok: total_size_mb_ok? },
    }
  end
end
