# for base controller
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # override
  def after_sign_in_path_for(_resource)
    books_path
  end
end
