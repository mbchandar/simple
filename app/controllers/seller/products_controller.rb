class Seller::ProductsController < ApplicationController
  before_filter :authorize, :except => [:show,:search]
  uses_tiny_mce :only => [:new, :create, :edit]  

  def index
    
    @user = User.find(current_user.id)
    logger.info("user id " + @user.id.to_s)
    @products = @user.products.all(:include => :offers)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1 GET /products/1.xml
  def show
    @product = Product.find(params[:id])
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
    #@product.user_id = current_user.id 
    process_file_uploads(@product)

    respond_to do |format|
      if @product.save
        @product.tag(params[:tags])       
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to(seller_products_url) }
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
    process_file_uploads(@product)
    
    respond_to do |format|
      if @product.update_attributes(params[:product])
        @product.tag(params[:tags])
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to([:seller,@product]) }
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
      format.html { redirect_to(seller_products_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def process_file_uploads(product)
    logger.info("[PRODUCT] uploading the product images")
    i=1
    while !params[:attachment]['file'+i.to_s].nil?
      product.assets.build(:data => params[:attachment]['file'+i.to_s])
      i=i+1
    end
  end

end
