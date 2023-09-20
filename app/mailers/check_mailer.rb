# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def failed
    @check = params[:check]
    @repository = @check.repository
    @user = @repository.user

    mail to: user.email,
         subject: t('.subject', repository_name: @repository.name)
  end

  def with_issues
    @check = params[:check]
    @repository = @check.repository
    @user = @repository.user

    mail to: user.email,
         subject: t('.subject', repository_name: @repository.name)
  end
end
