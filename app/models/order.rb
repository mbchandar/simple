class Order < ActiveRecord::Base
  has_many :line_items
  validates_presence_of :name,:email,:pay_type,:address
  validates_length_of   :email,:within => 3..100
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  PAYMENT_TYPES = [
    [ "Check", "check" ],
    [ "Credit Card", "cc" ],
    [ "Purchase Order", "po" ],
    ["Paypal","pp"],
    ["Bank Deposits","bd"]
  ].freeze

  def self.my_products(user_id)
    Product.find(:all,:select=>[:id],:conditions=>['user_id = ?',user_id])
  end

  def self.pending_shipping(user_id)
    @my_products = Product.find(:all,:select=>[:id],:conditions=>['user_id = ?',user_id])
    @my_orders = LineItem.find(:all,:select=>[:id],:conditions=>['product_id in (?)',@my_products.each { |e| e.id.to_s + "," }])
    find(:all,:conditions=>['id in (?) and (shipped_at is null or shipped_at = "0000-00-00 00:00:00")',@my_orders.each { |e| e.id.to_s + "," }])
  end
  # unshipped orders, the dtm of shipment otherwise.
  def mark_as_shipped
    self.shipped_at = Time.now
  end
end
