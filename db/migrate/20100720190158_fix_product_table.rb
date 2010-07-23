class FixProductTable < ActiveRecord::Migration
  def self.up
    
    remove_column :products,:user_id
    remove_column :products,:price
    remove_column :products,:date_available
    add_column :products, :product_code, :string
    add_column :products, :version, :integer
    
    change_table :products do |t|
      t.references :category
      t.references :manufacturer
    end
    
  end

  def self.down
#    add_column :products,:user_id, :integer
    add_column :products,:price, :integer
    add_column :products,:date_available, :datetime
    remove_column :products, :product_code
    remove_column :products, :version
    remove_column :products, :category_id
    remove_column :products, :manufacturer_id
   end
end
