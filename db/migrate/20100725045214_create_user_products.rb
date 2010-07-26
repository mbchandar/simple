class CreateUserProducts < ActiveRecord::Migration
  def self.up
    create_table :user_products,:id => false do |t|
      t.references :user
      t.references :product
      t.timestamps
    end
  end

  def self.down
    drop_table :user_products
  end
end
