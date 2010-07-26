class Product < ActiveRecord::Base
  acts_as_taggable

  Max_Attachments = 5
  Max_Attachment_Size = 1.megabyte

  has_many :user_products
  has_many :user_product_offers, :dependent => :destroy
  has_many :offers, :through => :user_product_offers, :source => :offer
  has_many :users, :through => :user_products

  accepts_nested_attributes_for :offers, :reject_if => lambda {|a| a[:list_price].blank? },:allow_destroy => true
  #accepts_nested_attributes_for :user_product_offers, :allow_destroy => true
  #accepts_nested_attributes_for :user_products,:allow_destroy => true
  
  has_many :assets, :as => :attachable, :dependent => :destroy, :class_name => "Assets"
  
  has_many :line_items
  has_many :reviews
  #has_many :product_images, :dependent => :destroy
  
  belongs_to :categories
  belongs_to :manufacturers
  
  has_and_belongs_to_many :tags
  before_save :encode_html
  after_update :save_images

  #validate :validate_attachments

  def validate_attachments
    errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if assets.length > Max_Attachments
    assets.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
  end

  def self.search(keyword)
    find(:all,:conditions =>["title LIKE ? or description LIKE ? ",'%'+keyword+'%','%'+keyword+'%'])
  end

  def encode_html
    #self.description = ae_some_html(self.description)
    self.version = 1
    self.description = CGI.escapeHTML(self.description)
  end
  
  def good_description
    CGI.unescapeHTML(self.description)
  end
  
  def image_attributes=(image_attributes)
    image_attributes.each do |attributes|
      if attributes[:id].blank?
        product_images.build(attributes)
      else
        product_image = product_images.detect { |t| t.id == attributes[:id].to_i}
        product_image.attributes = attributes
      end
    end
  end

  def save_images    
    #TODO image resize
  end
  
  def seo_text
    "#{title.downcase.gsub(/[^a-z0-9]+/i, '-')}-#{id}"
  end

  def to_reviews
    "#{title.downcase.gsub(/[^a-z0-9]+/i, '-')}-#{id}#reviews"
  end

end
