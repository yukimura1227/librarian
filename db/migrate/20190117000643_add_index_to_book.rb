class AddIndexToBook < ActiveRecord::Migration[5.2]
  def change
    add_index :books, :order_id
    add_index :books, :user_id
  end
end
