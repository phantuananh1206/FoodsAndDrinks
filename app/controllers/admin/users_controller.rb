class Admin::UsersController < Admin::BaseController
  before_action :load_user, only: %i(edit update destroy)

  def index
    @users = User.order_by_name.paginate(page: params[:page],
      per_page: Settings.page.per_page)
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "edit_user.edit_success"
      redirect_to admin_users_path
    else
      flash.now[:danger] = t "edit_user.edit_fail"
      render :edit
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      if params[:role] == "member"
        delete_member
      elsif params[:role] == "block"
        block
      elsif params[:role] == "unblock"
        unblock
      end
      redirect_to admin_users_path
    end
  rescue StandardError
    flash[:danger] = t "admin.dlt_fail"
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password,
                  :password_confirmation, :phone_number, :address
  end

  def load_user
    return if @user = User.find_by(id: params[:id])

    flash[:danger] = t "admin.user.not_found"
    redirect_to admin_users_path
  end

  def delete_member
    @order_accept = @user.orders.accepted
    @order_shipping = @user.orders.shipping
    @order_delivered = @user.orders.delivered
    if @order_shipping.present? || @order_accept.present?
      flash[:warning] = t "admin.warning"
    elsif @order_delivered.present?
      flash[:warning] = t "admin.warning_dlt"
    else
      update_quantity_delete_user
      @user.destroy
      flash[:success] = t "admin.success_dlt"
    end
  end

  def block
    @user.block!
    flash[:info] = t "admin.success_block"
  end

  def unblock
    @user.member!
    flash[:info] = t "admin.success_unblock"
  end

  def back_quantity_delete orders
    orders.map(&:update_quantity_product_cancel)
  end

  def update_quantity_delete_user
    @order_wating = @user.orders.waiting
    @order_confirm = @user.orders.confirmed
    back_quantity_delete @order_confirm if @order_confirm.present?
    back_quantity_delete @order_wating if @order_wating.present?
  end
end
