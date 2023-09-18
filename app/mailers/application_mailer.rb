# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'repository_check@example.com'
  layout 'mailer'
end
