class Assets < ActiveRecord::Base
  
  has_attached_file :data,
                    :url  => "/assets/:attachment/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/:attachment/:id/:style/:basename.:extension",
                    :styles => { :normal => '200x200>', :small => '100x100>' }
                    
                    
  belongs_to :attachable, :polymorphic => true
  
  def url(*args)
    data.url(*args)
  end
  
  def name
    data_file_name
  end
  
  def content_type
    data_content_type
  end
  
  def file_size
    data_file_size
  end

end
