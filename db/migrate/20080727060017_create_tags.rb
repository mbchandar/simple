class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name,:limit=>255,:default=>:null
      t.timestamps
    end
    create_table :products_tags,:id => false do |t|
      t.references :tag
      t.references :product
      t.timestamps
    end
    add_index :tags,:name
  end
  def self.down
    drop_table :tags
    drop_table :products_tags
  end
end
