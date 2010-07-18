class Review < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  validates_presence_of :body

  def self.get_reviews_by_product(id)
    find(:all,:conditions=>['product_id = ?',id],:order => "created_at ASC")
  end
end
