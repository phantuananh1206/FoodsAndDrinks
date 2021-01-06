class OrderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject
  #
  def order_confirmation order, user
    @order = order
    @user = user
    mail to: @user.email, subject: t("mailers.confirm_order")
  end
end
