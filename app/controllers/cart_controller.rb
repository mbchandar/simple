class CartController < ApplicationController

  def checkout
    @cart = find
    @items = @cart.items
    if @items.empty?
      flash[:info] = "There is nothing in your cart!"
      redirect_back_or_default('/')
    else
      @order = Order.new
    end
  end

  def save_order
    @cart = find
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

  def add
    begin
      product = Product.find(params[:id])
      @cart = find
      @current_item = @cart.add_product(product)
      flash[:notice] = "Product <b>#{product.title}</b> added to cart!"
    rescue
      logger.error("[CART]Attempt to access invalid product #{params[:id]}")
      flash[:error] = 'Product does not exist'
#      redirect_to(:action => 'index')
    end
    redirect_to product
  end

  def empty
    @cart = find
    @items = @cart.items    
    if !@items.empty?
      session[:cart] = nil
      flash[:notice] = "Your Cart is now Empty!"
    end
    redirect_back_or_default('/')
  end

  private
  def find
    logger.info("[CART] find cart or create cart " + session.inspect)
    session[:cart] ||= Cart.new
  end
end
