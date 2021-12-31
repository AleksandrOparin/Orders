class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :cost, null: false
      t.date :time_to_complete, null: false

      t.timestamps
    end
  end
end
