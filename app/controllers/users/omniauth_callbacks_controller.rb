module Users
  # Omni callback
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :validate_email_domain, only: :google_oauth2
    def google_oauth2
      # You need to implement the method below in your model
      # (e.g. app/models/user.rb)
      @user = User.find_for_google(request.env['omniauth.auth'])

      if @user.persisted?
        flash[:notice] =
          I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] =
          request.env['omniauth.auth'].except(:extra)
        # Removing extra as it can overflow some session stores

        redirect_to(
          new_user_registration_url,
          alert: @user.errors.full_messages.join("\n")
        )
      end
    end

    private

    def validate_email_domain
      email = request.env['omniauth.auth'].info.email
      if email.present?
        allow_domains = ENV['LOGIN_ALLOW_DOMAIN_CSV'].split(',')
        unless allow_domains.any? { |domain| email.end_with?("@#{domain}") }
          redirect_to(
            root_path,
            alert: "allow email domain : [#{ENV['LOGIN_ALLOW_DOMAIN_CSV']}]"
          )
        end
      end
    end
  end
end
