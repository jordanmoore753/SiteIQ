class CreateSites < ActiveRecord::Migration[8.1]
  def change
    create_table :sites do |t|
      t.string :url

      t.timestamps
    end
  end
end
