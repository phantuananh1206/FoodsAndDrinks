class RatingsController < ApplicationController
  before_action :logged_in_user, only: :create

  def index
    @product = Product.find_by id: params[:product_id]
    if @product
      @ratings = @product.ratings
    else
      flash[:danger] = t "carts.product_not_found"
      redirect_to root_path
    end
  end

  def create
    @rating = Rating.find_by user_id: current_user.id,
                            product_id: params[:product_id]
    if @rating.blank?
      @rating = current_user.ratings.build(rating_params)
      flash[:success] = t "ratings.success" if @rating.save
    else
      flash[:danger] = t "ratings.already"
    end
    redirect_to product_ratings_path
  end

  private

  def rating_params
    params.require(:rating).permit :product_id, :rating, :content
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.please_log_in"
    redirect_to login_path
  end
end
