require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Librarian
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    I18n.config.available_locales = [:ja, :en]
    I18n.default_locale = :ja
    config.active_record.default_timezone = :local
    config.time_zone = 'Tokyo'
    config.slack_webhook_url  = ENV['SLACK_WEBHOOK_URL']
    config.slack_notify_to    = ENV['SLACK_NOTIFY_TO']
    config.application_domain = ENV['APPLICATION_DOMAIN']
  end
end
