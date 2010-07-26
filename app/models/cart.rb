class Cart
  attr_reader :items
  attr_reader :total_price

  def initialize
    @items = []
    @total_price = 0.0
  end

  def add_product(product)
    logger.info("[CART] add_product model")
    item = @items.find {|i| i.product_id == product.id}
    if item
      item.quantity += 1
    else
      item = LineItem.for_product(product)
      @items << item
    end
    @total_price += product.offers.price
  end
end
