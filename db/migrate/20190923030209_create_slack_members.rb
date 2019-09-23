class CreateSlackMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_members do |t|
      t.string :slack_id
      t.string :slack_user_name
      t.integer :user_id

      t.timestamps
    end
    add_index :slack_members, :user_id
    add_index :slack_members, :slack_user_name
  end
end
