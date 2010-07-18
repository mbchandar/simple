class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :name,:limit=>100,:null=>false
      t.string :email,:limit=>255,:null=>false
      t.text :address,:null=>false
      t.string :pay_type,:limit=>10
      t.timestamps
    end
    add_column :line_items,:order_id,:integer,:null=>false
    execute 'ALTER TABLE line_items ADD CONSTRAINT fk_items_order FOREIGN KEY ( order_id ) REFERENCES orders(id)'
  end

  def self.down
    drop_table :orders
    remove_column :line_items,:order_id    
  end
end
