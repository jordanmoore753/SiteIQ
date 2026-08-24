class CreateCaptures < ActiveRecord::Migration[8.1]
  def change
    create_table :captures do |t|
      t.belongs_to :site, null: false, foreign_key: true

      t.timestamps
    end
  end
end
