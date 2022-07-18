class FriendshipMailer < ApplicationMailer
  def invintation_mail
    @user_from = params[:friendship].user_from
    @user_to = params[:friendship].user_to
    mail(to: @user_to.email, subject: I18n.t('action_mailer.friendships.subjects.invintation_mail'))
  end

  def declined_mail
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    mail(to: @user_from.email, subject: I18n.t('action_mailer.friendships.subjects.declined_email'))
  end

  def accepted_mail
    @user_from = params[:friendship].user_from
    @user_to = params[:friendship].user_to
    mail(to: @user_from.email, subject: I18n.t('action_mailer.friendships.subjects.accepted_email'))
  end
end
