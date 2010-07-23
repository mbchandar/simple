class ProductImage < ActiveRecord::Base
  belongs_to :product
  has_attachment :content_type => :image,
    :storage => :file_system,
    :max_size => 2000.kilobytes,
    :resize_to => '100x100>',
    :thumbnails => { :thumb => '50x50>' },
    :path_prefix => 'public/products'    
   
  validates_as_attachment
  attr_accessor :should_destroy

  def should_destroy?
    should_destroy.to_i == 1
  end

end
