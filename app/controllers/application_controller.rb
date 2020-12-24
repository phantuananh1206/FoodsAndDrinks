class ApplicationController < ActionController::Base
  before_action :set_locale, :load_category

  include SessionsHelper

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_category
    @categories = Category.orders_alphabet_category.select(:id, :name)
  end
end
