# frozen_string_literal: true

require 'slack'

Slack.configure do |config|
  config.token = ENV['SLACK_ACCESS_TOKEN']
end
