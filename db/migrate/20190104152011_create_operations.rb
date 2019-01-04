class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.string :type
      t.integer :user_id
      t.integer :book_id

      t.timestamps
    end
  end
end
