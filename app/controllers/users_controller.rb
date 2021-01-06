class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(show edit update edit_password)
  before_action :load_user, only: %i(show edit update)

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

  def edit; end

  def update
    if @user.update user_params.merge(params.require(:user).permit(:address))
      flash[:success] = t "edit_user.edit_success"
      redirect_to @user
    else
      flash.now[:danger] = t "edit_user.edit_fail"
      render :edit
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user&.authenticate(params[:user][:password_curent])
      if @user.update user_params
        flash[:success] = t "edit_user.edit_pw_success"
        redirect_to current_user
      else
        flash.now[:danger] = t "edit_user.pw_format_fail"
        render :edit_password
      end
    else
      flash.now[:danger] = t "edit_user.curr_pw_fail"
      render :edit_password
    end
  end

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
