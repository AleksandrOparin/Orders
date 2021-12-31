# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionHelper
  include Internationalization

  before_action :require_login

  private

  def require_login
    redirect_to session_login_url unless signed_in?
  end
end
