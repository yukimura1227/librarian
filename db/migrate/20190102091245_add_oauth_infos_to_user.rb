class AddOauthInfosToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :uid, :string
    add_column :users, :token, :string
    add_column :users, :meta, :text
    add_column :users, :provider, :string
  end
end
