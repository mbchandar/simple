class Rating < ActiveRecord::Base
  validates_presence_of     :rater_id, :rater_type, :ratable_type, :ratable_id, :score
  validates_numericality_of :score, :greater_than => 0, :less_than => 6
  validates_uniqueness_of :rater_id, :scope => [:rater_type, :ratable_type, :ratable_id]

  belongs_to :rater,   :polymorphic => true
  belongs_to :ratable, :polymorphic => true
end
