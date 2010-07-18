class Product < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_many :line_items
  has_many :reviews
  has_many :product_images, :dependent => :destroy
  has_and_belongs_to_many :tags
  before_save :encode_html
  after_update :save_images

  def self.search(keyword)
    find(:all,:conditions =>["title LIKE ? or description LIKE ? ",'%'+keyword+'%','%'+keyword+'%'])
  end

  def encode_html
    self.description = ae_some_html(self.description)
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
    product_images.each do |image|
      if image.should_destroy?
        image.destroy
      else
        image.save(false)
      end
    end
  end
  
  def seo_text
    "#{title.downcase.gsub(/[^a-z0-9]+/i, '-')}-#{id}"
  end

  def to_reviews
    "#{title.downcase.gsub(/[^a-z0-9]+/i, '-')}-#{id}#reviews"
  end

  def ae_some_html(s)
    # converting newlines
    s.gsub!(/\r\n?/, "\n")
 
    # escaping HTML to entities
    s = s.to_s.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
 
    # blockquote tag support
    s.gsub!(/\n?&lt;blockquote&gt;\n*(.+?)\n*&lt;\/blockquote&gt;/im, "<blockquote>\\1</blockquote>")
 
    # other tags: b, i, em, strong, u
    %w(b i em strong u).each { |x|
         s.gsub!(Regexp.new('&lt;(' + x + ')&gt;(.+?)&lt;/('+x+')&gt;',
                 Regexp::MULTILINE|Regexp::IGNORECASE), 
                 "<\\1>\\2</\\1>")
        }
 
    # A tag support
    # href="" attribute auto-adds http://
    s = s.gsub(/&lt;a.+?href\s*=\s*['"](.+?)["'].*?&gt;(.+?)&lt;\/a&gt;/im) { |x|
            '<a href="' + ($1.index('://') ? $1 : 'http://'+$1) + "\">" + $2 + "</a>"
          }
 
    # replacing newlines to <br> ans <p> tags
    # wrapping text into paragraph
    s = "<p>" + s.gsub(/\n\n+/, "</p>\n\n<p>").
            gsub(/([^\n]\n)(?=[^\n])/, '\1<br />') + "</p>"
 
    s      
  end
end
