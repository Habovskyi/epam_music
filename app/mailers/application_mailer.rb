class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.gmail
  layout 'mailer'
end
