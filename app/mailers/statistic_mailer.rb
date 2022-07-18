class StatisticMailer < ApplicationMailer
  DATE_FORMAT = '%d %b, %Y %H:%M %Z'.freeze

  def statistic_mail(statistic, statistic_to_compare, time_period)
    @statistic_presenter = ::Statistics::MailPresenter.new(statistic, statistic_to_compare, time_period)
    mail(to: ::AdminUser.pluck(:email),
         subject: I18n.t('action_mailer.statistic.subjects.send',
                         time_period: @statistic_presenter.formated_time_period,
                         current_date: Time.zone.now.strftime(DATE_FORMAT)))
  end
end
