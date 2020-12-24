class CartsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :update
  before_action :load_product, :check_quantity, only: %i(create)
  before_action :current_carts, except: %i(clear_cart)

  def index
    flag = false
    @order_details = Array.new
    session[:carts].each do |product_id, quantity|
      @product = Product.find_by id: product_id
      if @product
        @order_details << OrderDetail.new(product_id: @product.id,
        quantity: quantity, price: @product.price)
      else
        flag = true
        session[:carts].delete(product_id)
      end
    end
    total_price
    flash.now[:danger] = t "carts.product_not_found" if flag
  end

  def create
    if @carts.include?(params[:product_id])
      @carts[params[:product_id]] += params[:quantity].to_i
    else
      @carts[params[:product_id]] = params[:quantity].to_i
    end
    session[:carts] = @carts
    flash[:success] = t "carts.add_success"
    respond_to do |format|
      format.js
    end
  end

  def update
    if @carts.include?(params[:product_id])
      @product = Product.find_by id: params[:product_id]
      update_success params if @product
    else
      flash[:danger] = t "product_detail.product_find_nil"
    end
  end

  def destroy
    if @carts.reject!{|key| key.to_i == params[:id].to_i}
      flash[:success] = t "carts.delete_success"
      @id = params[:id]
      total_price
    else
      flash[:danger] = t "carts.delete_fail"
    end
    session[:cart] = @carts
  end

  def clear_cart
    session.delete :carts
    redirect_to carts_path
  end

  private

  def load_product
    return if @product = Product.find_by(id: params[:product_id])

    flash[:danger] = t "carts.product_not_found"
    redirect_to carts_path
  end

  def total_price
    @total_price = 0
    session[:carts].each do |product_id, quantity|
      @product = Product.find_by id: product_id
      next unless @product

      @total_price += @product.price * quantity
    end
  end

  def update_success params
    @carts[params[:product_id]] = params[:quantity].to_i
    @quantity = params[:quantity]
    @subtotal = @quantity.to_i * @product.price
    @id = params[:product_id]
    session[:carts] = @carts
    total_price
    flash[:success] = t "carts.update_success"
  end
end
