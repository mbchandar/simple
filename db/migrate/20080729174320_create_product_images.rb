class CreateProductImages < ActiveRecord::Migration
  def self.up
    create_table :product_images do |t|
      t.column :product_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :thumbnail, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :product_images
  end
end
