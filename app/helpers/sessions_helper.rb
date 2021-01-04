module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete :user_id
    session.delete :carts
    @current_user = nil
  end

  def remember_me user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
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
