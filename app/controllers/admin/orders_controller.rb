class Admin::OrdersController < Admin::BaseController
  before_action :load_order, only: %i(update)

  def index
    @orders = Order.by_created_at.paginate(page: params[:page],
      per_page: Settings.page.per_page)
  end

  def update
    if @order.canceled? || @order.delivered?
      flash[:danger] = t "order.status_error"
    else
      update_status_order
    end
    redirect_to admin_orders_path
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:danger] = t "order.not_found"
    redirect_to admin_orders_path
  end

  def update_status_order
    case params[:status].to_i
    when Order.statuses[:accepted]
      accept_order
    when Order.statuses[:refused]
      refuse_order
    when Order.statuses[:shipping]
      shipping_order
    else
      flash[:danger] = t "order.status_error"
    end
  end

  def accept_order
    @order.accepted!
    flash[:success] = t "order.status_success"
  end

  def refuse_order
    @order.refused!
    flash[:success] = t "order.status_success"
  end

  def shipping_order
    @order.shipping!
    flash[:success] = t "order.status_success"
  end
end
