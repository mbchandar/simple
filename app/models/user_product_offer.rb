class UserProductOffer < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  belongs_to :offer
  before_save :associate_user

  def associate_user
    self.user_id = current_user.id
  end
end
