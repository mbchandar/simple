class ProductOffer < ActiveRecord::Base
  belongs_to :product
  belongs_to :offers
end
