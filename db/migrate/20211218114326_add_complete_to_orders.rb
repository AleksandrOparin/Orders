class AddCompleteToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :complete, :boolean
  end
end
