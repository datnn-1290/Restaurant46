class UserMailer < ApplicationMailer

  def user_mail user
    @user = user
    # @order = order
    # @dish = dish
    mail to: user.email, subject: t("info_order")
  end
end
