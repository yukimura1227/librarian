# frozen_string_literal: true

# login user
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: %i(google_oauth2)

  has_many :books

  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)

    user = create_user_by_google(auth) unless user

    user
  end

  def self.create_user_by_google(oauth_data)
    User.create(
      email:    oauth_data.info.email,
      name:     oauth_data.info.name,
      provider: oauth_data.provider,
      uid:      oauth_data.uid,
      token:    oauth_data.credentials.token,
      meta:     oauth_data.to_yaml
    )
  end
  private_class_method :create_user_by_google
end
