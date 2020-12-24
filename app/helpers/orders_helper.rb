module OrdersHelper
  def cal_total_order order
    @total = 0
    order_details = order.order_details
    @total = order_details.reduce(0) do |sum, o|
      sum + o.quantity * o.price
    end
    return @total - order.voucher.discount if order.voucher

    @total
  end

  def check_voucher? order
    order.voucher
  end

  def cal_old_total
    @total
  end

  def total_price_order
    @order.order_details.reduce(0) do |sum, order_detail|
      if order_detail.valid?
        sum + (order_detail.quantity * order_detail.price)
      else
        0
      end
    end
  end
end
