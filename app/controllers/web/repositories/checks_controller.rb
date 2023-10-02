# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    repository = Repository.find params[:repository_id]
    authorize repository

    @check = Repository::Check.find params[:id]
    @issues = JSON.parse(@check.issues, symbolize_names: true) if @check.issues.present?
  end

  def create
    repository = current_user.repositories.find(params[:repository_id])
    authorize repository

    if RepositoryService.check!(repository)
      f :success, redirect: repositories_path
    else
      f :error, redirect: repositories_path, status: :unprocessable_entity
    end
  end
end
