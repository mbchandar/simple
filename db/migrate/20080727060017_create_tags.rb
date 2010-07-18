class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name,:limit=>255,:default=>:null
    end
    create_table :tags_products do |t|
      t.integer :tag_id
      t.integer :product_id
    end
    add_index :tags,:name
  end
  def self.down
    drop_table :tags
  end
end
