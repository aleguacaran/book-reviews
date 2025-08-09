# frozen_string_literal: true

# Base class for ActionMailer mailers
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
