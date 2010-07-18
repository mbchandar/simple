class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :rater_id
      t.string   :rater_type
      t.integer  :ratable_id
      t.string   :ratable_type
      t.integer  :score
      
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
