class SearchsController < ApplicationController
  before_action :check_key_search, only: %i(index)

  def index
    @products = Product.filter_product_by_name(@key)
                       .paginate(page: params[:page],
                       per_page: Settings.page.per_page)

    return unless @products.empty?

    flash[:danger] = t "search.nil"
    redirect_to root_path
  end

  private

  def check_key_search
    @key = params[:key]
    return if @key.present?

    flash[:warning] = t "search.nil_key"
  end
end
