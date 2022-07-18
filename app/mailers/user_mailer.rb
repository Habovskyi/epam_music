class UserMailer < ApplicationMailer
  def achievement_notification_mail
    @user = params[:user]
    mail(to: @user.email, subject: I18n.t('action_mailer.users.subjects.achievement_notification'))
  end
end
