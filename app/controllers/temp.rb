class ShoppingCartController < ApplicationController
  def checkout
    @cart = find_cart
    @items = @cart.items
    if @items.empty?
      flash[:info] = "There is nothing in your cart!"
      redirect_back_or_default('/')
    else
      @order = Order.new
    end
  end

  def save_order
    @cart = find_cart
    @items = @cart.items
    @order = Order.new(params[:order])
    @order.line_items << @items
    if @order.save
      session[:cart] = nil
      flash[:notice] = "Thank you for placing the Order."
      redirect_back_or_default('/')
    else
      render(:action=>:checkout)
    end
  end
  def add_to_cart
    begin
      product = Product.find(params[:id])
      @cart = find_cart
      @current_item = @cart.add_product(product)
      flash[:notice] = "Product <b>#{product.title}</b> added to cart!"
      redirect_back_or_default('/')
    rescue
      logger.error("Attempt to access invalid product #{params[:id]}")
      flash[:error] = 'Product does not exist'
      redirect_to(:action => 'index')
    end
  end

  def empty_cart
    @cart = find_cart
    @items = @cart.items    
    if !@items.empty?
      session[:cart] = nil
      flash[:notice] = "Your Cart is now Empty!"
    end
    redirect_back_or_default('/')
  end
  private
  def find_cart
    session[:cart] ||= Cart.new
  end

end
