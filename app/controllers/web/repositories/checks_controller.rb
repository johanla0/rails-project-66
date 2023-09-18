# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    repository = current_user.repositories.find(params[:repository_id])
    authorize repository

    @check = Repository::Check.find params[:id]
    # FIXME: Update according to final JSON structure
    @issues = JSON.parse(@check.issues)['lines'] if @check.issues.present?
  end

  def create
    repository = current_user.repositories.find(params[:repository_id])
    authorize repository

    if RepositoryService.check!(repository)
      f :success, redirect: repositories_path(repository)
    else
      f :error, redirect: repositories_path(repository), status: :unprocessable_entity
    end
  end
end
