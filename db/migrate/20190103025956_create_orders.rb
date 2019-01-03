class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :title
      t.datetime :order_time
      t.integer :state, default: 0
      t.text :url
      t.text :origin_html

      t.timestamps
    end
  end
end
