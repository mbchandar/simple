class LineItem < ActiveRecord::Base
  belongs_to :offer
  belongs_to :order
  def self.for_offer(offer)
    item = self.new
    item.quantity = 1
    item.product = offer
    item.unit_price = offer.offer_price
    item
  end
end
