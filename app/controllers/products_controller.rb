class ProductsController < ApplicationController
  # GET /products GET /products.xml  
  before_filter :authorize, :except => [:show,:search]

  def index
  #  @products = Product.find(:all,:conditions=>['user_id = ?',current_user.id])
    @products = Product.find(:all,:include => [:offers,:assets])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1 GET /products/1.xml
  def show
    name = params[:id]
    logger.info("ROSE " + name)
    @product = Product.find(name.reverse)    
    @reviews = Review.get_reviews_by_product(@product.id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end
  

  # GET /products/new GET /products/new.xml
  def new
    @product = Product.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @product.description = CGI.unescapeHTML(@product.description);
  end

  # POST /products POST /products.xml
  def create     
    @product = Product.new(params[:product])    
    @product.user_id = current_user.id    
    respond_to do |format|
      if @product.save
        @product.tag(params[:tags])       
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to(@product) }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1 PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        @product.tag(params[:tags])
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to(@product) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 DELETE /products/1.xml
  def destroy
    begin
      @product = Product.find(params[:id])
      @product.destroy
    rescue
      logger.info("I cannot delete the product")
      flash[:error] = "Product <b>#{@product.title}</b> cannot be deleted"
    end

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end


  def save_reviews
    @review = Review.new(params[:review])
    @review.user_id = current_user.id
    if @review.save
      flash[:notice] = 'Review was successfully submitted.'
    else  
      flash[:error] = 'Some error occurred.'
    end
    redirect_to :back
  end

  # related to orders
  def my_orders
    @my_products = Order.my_products(current_user.id)
    @pending_orders = Order.pending_shipping(current_user.id)
  end

  # Shipping related
  def ship
    count = 0
    if things_to_ship = params[:to_be_shipped]
      count = do_shipping(things_to_ship)
      if count > 0
        count_text = pluralize(count, "order")
        flash[:notice] = "#{count_text} marked as shipped"
      end
    end
    @pending_orders = Order.pending_shipping(current_user.id)
    redirect_to(orders_url)
  end

  private
  def do_shipping(things_to_ship)
    count = 0
    things_to_ship.each do |order_id, do_it|
      if do_it == "yes"
        order = Order.find(order_id)
        order.mark_as_shipped
        order.save
        count += 1
      end
    end
    count
  end

  def pluralize(count, noun)
    case count
    when 0: "No #{noun.pluralize}"
    when 1: "One #{noun}"
    else "#{count} #{noun.pluralize}"
    end
  end
  
  

end
