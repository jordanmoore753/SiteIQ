class AddMetricsToCaptures < ActiveRecord::Migration[8.1]
  def change
    add_column :captures, :ttfb, :float
    add_column :captures, :lcp, :float
    add_column :captures, :count_404, :integer
    add_column :captures, :count_500, :integer
    add_column :captures, :total_size_mb, :float
  end
end
