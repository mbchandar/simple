class Cart
  attr_reader :items
  attr_reader :total_price

  def initialize
    @items = []
    @total_price = 0.0
  end

  def add_product(product,offer)
    item = @items.find {|i| i.offer == offer}
    if item
      item.increment_quantity
    else
      item = CartItem.new(offer)
      @items << item
    end
    @total_price += offer.offer_price
  end
end

class CartItem
  attr_reader :offer, :quantity
  def initialize(offer)
    @offer = offer
    @quantity = 1
  end
  def increment_quantity
    @quantity += 1
  end
  def title
    @offer.title
  end
  def price
    @offer.offer_price * @quantity
  end
end
