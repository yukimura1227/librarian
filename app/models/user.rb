# frozen_string_literal: true

# login user
class User < ActiveRecord::Base
  include Utility::Slack
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: %i(google_oauth2)

  has_many :books
  has_many :rental_operations, class_name: 'Operation::Rental'
  has_many :return_operations, class_name: 'Operation::Return'

  has_one :slack_member

  scope :not_have_slack_member, lambda {
    User.left_joins(:slack_member).where(slack_members: { id: nil })
  }

  def self.notify_slack_member_not_bind
    notify_slack("#{not_have_slack_member.pluck(:email).join(',')} は、slackのユーザとの紐付けができていないようです。このページにアクセスして紐付けを実施してください。：#{Rails.application.config.application_domain}/#{Rails.application.routes.url_helpers.slack_members_path}")
  end

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

  def slack_name
    "<@#{slack_member.slack_user_name}>"
  end
end
