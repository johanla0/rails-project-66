# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    repository = Repository.find params[:repository_id]
    authorize repository, policy_class: Repository::CheckPolicy

    @check = Repository::Check.find params[:id]
    @issues = JSON.parse(@check.issues, symbolize_names: true) if @check.issues.present?
  end

  def create
    repository = current_user.repositories.find params[:repository_id]
    authorize repository, policy_class: Repository::CheckPolicy

    if RepositoryService.check!(repository)
      f :success, redirect: repository_path(repository)
    else
      f :error, redirect: repository_path(repository), status: :unprocessable_entity
    end
  end
end
