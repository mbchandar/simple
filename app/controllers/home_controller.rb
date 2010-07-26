class HomeController < ApplicationController
  
  def index
    if logged_in? && !current_user.active?
      flash[:info]= "Please activate the account from your email account!"
    end
    if logged_in?
      #@products = Product.find(:all,:conditions=>['user_id != ?',current_user.id])
      @products = Product.find(:all)
      #@cart = find_cart
      @items = @cart.items
    else
      @products = Product.find(:all)
      #@cart = find_cart
      #@items = @cart.items
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def search
    @search = params[:home][:search]
    @products = Product.search(@search)
    @cart = find_cart
    @items = @cart.items 
    render :partial => "catalog",:layout => 'application'
  end
  
end
