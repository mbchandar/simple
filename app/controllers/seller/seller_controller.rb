class Seller::SellerController < ApplicationController
  before_filter :authorize
  layout "seller"
end
