class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :product_id,:null => false
      t.integer :user_id, :null => false
      t.text :body,:null=> false
      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
