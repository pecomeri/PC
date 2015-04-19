class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :asin
      t.string :search_index
      t.float :price_jp
      t.float :price_us
      t.integer :rank_amazon
      t.datetime :check_date

      t.timestamps null: false
    end
  end
end
