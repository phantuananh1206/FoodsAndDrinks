class CategoriesController < ApplicationController
  before_action :find_category, only: %i(show)

  def show
    @products = @category.products.order_alphabet_name
                         .paginate(page: params[:page],
                         per_page: Settings.page.per_page)
  end

  private

  def find_category
    return if @category = Category.find_by(id: params[:id])

    flash[:danger] = t "search.nil_cate"
    redirect_to root_path
  end
end
