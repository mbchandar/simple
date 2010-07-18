class OrdersShippedAt < ActiveRecord::Migration
  def self.up
    add_column :orders,:shipped_at,:datetime,:null=>true
  end

  def self.down
    remove_column :orders,:shipped_at
  end
end
