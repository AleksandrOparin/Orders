class AddUserToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :user, null: false, foreign_key: true
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
