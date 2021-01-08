class OrderConfirmationsController < ApplicationController
  before_action :load_order, :check_expiration, only: %i(edit)

  def edit
    user = User.find_by email: params[:email]
    return unless user && @order.authenticated?(:confirmation, params[:token])

    if @order.waiting?
      @order.confirm
      flash.now[:success] = t "order.confirm_success"
    else
      flash[:danger] = t "order.status_error"
      redirect_to root_path
    end
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:danger] = t "order.nil_order"
    redirect_to root_path
  end

  def check_expiration
    return unless @order.order_confirm_expired?

    flash[:danger] = t "order.confirm_expired"
    redirect_to root_path
  end
end
