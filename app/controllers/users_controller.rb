class UsersController < ApplicationController
  before_action :logged_in_user, :load_user, only: %i(show)

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t "account.active_account"
      redirect_to root_path
    else
      render :new
    end
  end

  def show; end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password,
                  :password_confirmation, :phone_number
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.please_log_in"
    redirect_to login_path
  end

  def load_user
    return if @user = User.find_by(id: params[:id])

    flash[:warning] = t "user.not_found"
    redirect_to root_path
  end
end
