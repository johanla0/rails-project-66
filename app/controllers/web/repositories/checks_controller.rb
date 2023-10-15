# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    repository = Repository.find params[:repository_id]
    authorize repository, policy_class: Repository::CheckPolicy

    @check = repository.checks.find params[:id]
    @issues = JSON.parse(@check.issues, symbolize_names: true) if @check.issues.present?
  end

  def create
    repository = current_user.repositories.find params[:repository_id]
    authorize repository, policy_class: Repository::CheckPolicy

    check = Repository::Check.create(repository:)
    if check
      CheckRepositoryJob.perform_async(check.id)
      f :success, redirect: repository_path(repository)
    else
      f :error, redirect: repository_path(repository), status: :unprocessable_entity
    end
  end
end
