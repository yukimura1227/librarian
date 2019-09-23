# frozen_string_literal: true

class SlackMember < ApplicationRecord
  def self.refresh_slack_members
    return unless ENV['SLACK_ACCESS_TOKEN']

    Slack.users_list['members'].each do |u|
      SlackMember.find_or_create_by(
        slack_id: u['id'],
        slack_user_name: u['name']
      )
    end
  end
end
