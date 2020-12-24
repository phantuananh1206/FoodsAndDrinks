class OrderDetailsController < ApplicationController
  before_action :load_order, only: :index

  def index
    @order_details = @order.order_details
  end

  private

  def load_order
    @order = Order.find_by id: params[:order_id]
    return if @order

    flash[:danger] = t "order.not_found"
    redirect_to user_orders_path
  end
end
