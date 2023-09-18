# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def failed
    check = params[:check]
    error = params[:error]
    repository = check.repository
    user = repository.user
    repository_check_url = repository_check_url(repository, check)

    mail to: user.email,
         subject: t('.subject', repository_name: repository.full_name)
  end

  def with_issues
    check = params[:check]
    repository = check.repository
    user = repository.user
    repository_check_url = repository_check_url(repository, check)

    mail to: user.email,
         subject: t('.subject', repository_name: repository.full_name)
  end
end
