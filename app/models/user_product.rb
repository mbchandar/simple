class UserProduct < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  before_save :associate_user

  def associate_user
    self.user_id = current_user.id
  end
end
