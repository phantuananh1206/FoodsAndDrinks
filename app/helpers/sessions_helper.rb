module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete :user_id
    session.delete :carts
    @current_user = nil
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def current_carts
    session[:carts] ||= Hash.new
    @carts = session[:carts]
  end

  def check_quantity
    return if params[:quantity].to_i <= @product.quantity &&
              params[:quantity].to_i >= Settings.product.min_quantity

    flash[:danger] = t "carts.invalid_quantity"
    redirect_to root_path
  end

  def subtotal price, quantity
    price * quantity
  end

  def count_items
    @count_item = session[:carts].size if session[:carts]
  end

  def check_admin
    redirect_to root_path unless check_user_admin?
  end

  def check_user_admin?
    current_user.admin?
  end
end
