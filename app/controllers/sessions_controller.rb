class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      remember_me user
      redirect_back_or user
    else
      flash.now[:danger] = t("sessions.show_error")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
