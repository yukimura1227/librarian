# frozen_string_literal: true

#  slack  member
class SlackMember < ApplicationRecord
  def self.refresh_slack_members
    return unless ENV['SLACK_ACCESS_TOKEN']

    Slack.users_list['members'].each do |u|
      SlackMember.find_or_create_by(
        slack_id: u['id'],
        slack_user_name: u['name']
      )
    end
    preset_user_id
  end

  def self.preset_user_id
    where(user_id: nil).each do |r|
      u = User.where('email like ?', "#{r.slack_user_name}@%").first
      r.update(user_id: u.id) if u.present?
    end
  end
end
