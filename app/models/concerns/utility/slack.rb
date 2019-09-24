# frozen_string_literal: true

module Utility
  # for posting slack
  module Slack
    extend ActiveSupport::Concern
    def notify_slack(message)
      return if Rails.application.config.slack_webhook_url.blank?

      notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
      notifier.ping(message, parse: 'full')
    end
  end
end
