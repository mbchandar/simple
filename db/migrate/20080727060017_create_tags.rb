class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name,:limit=>255,:default=>:null
    end
    create_table :products_tags do |t|
      t.references :tag
      t.references :product
    end
    add_index :tags,:name
  end
  def self.down
    drop_table :tags
    drop_table :products_tags
  end
end
