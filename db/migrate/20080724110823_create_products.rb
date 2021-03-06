class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.string :image_url
      t.datetime :date_available
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
