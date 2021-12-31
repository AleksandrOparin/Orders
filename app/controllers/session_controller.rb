# frozen_string_literal: true

class SessionController < ApplicationController
  skip_before_action :require_login, only: %i[login create]
  before_action :require_login, only: %i[logout]

  def login; end

  def create
    user = User.find_by(username: params[:login])

    if user&.authenticate(params[:password])
      sign_in user
      redirect_to root_path
    else
      flash[:danger] = t 'invalid_login_or_password'
      redirect_to session_login_path
    end
  end

  def logout
    sign_out
    redirect_to session_login_path
  end
end
