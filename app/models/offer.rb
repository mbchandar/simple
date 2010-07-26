class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  has_many :user_product_offers
#  has_many :users, :through => :user_product_offers
#  has_many :products, :through => :user_product_offers
end
