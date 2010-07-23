class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.references :user
      t.references :product
      t.string :sku
      t.float :list_price
      t.float :offer_price
      t.integer :quantity
      t.integer :is_disabled
      t.datetime :date_available
      t.datetime :expired_at      
      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end
