class StaticPagesController < ApplicationController
  def home
    @products = Product.order_alphabet_name
                       .paginate(page: params[:page],
                       per_page: Settings.page.per_page)
  end
end
