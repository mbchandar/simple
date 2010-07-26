class CreateUserProductOffers < ActiveRecord::Migration
  def self.up
    create_table :user_product_offers,:id => false do |t|
      t.references :product
      t.references :offer
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :user_product_offers
  end
end
