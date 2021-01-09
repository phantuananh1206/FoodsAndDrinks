class SessionsController < ApplicationController
  def new; end

  def create
    user = User.not_block_user.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      check_user_activated? user
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
