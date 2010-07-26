class CartController < ApplicationController

  def index
    @cart = find
    @items = @cart.items

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

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
    logger.info("[CART][ADD] which product is being added ? " + params[:id])
    
    begin
      product = Product.find(params[:id])
      offer = product.offers.first
      @cart = find
      logger.info(@cart.inspect + product.inspect)
      @current_item = @cart.add_product(product,offer)
      flash[:notice] = "Product <b>#{product.title}</b> added to cart!"
    rescue Exception => exc
      logger.error("[CART]Attempt to access invalid product #{params[:id]} #{exc.message}")
      raise exc
      flash[:error] = 'Product does not exist'
    end
    @items = @cart.items
    respond_to do |format|
      format.html { redirect_to cart_path}
      format.xml  { render :xml => @products }
      format.js
    end
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
