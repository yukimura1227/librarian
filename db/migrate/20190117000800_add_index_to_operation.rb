class AddIndexToOperation < ActiveRecord::Migration[5.2]
  def change
    add_index :operations, :user_id
    add_index :operations, :book_id
  end
end
