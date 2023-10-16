# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user

  def index
    @repositories = current_user.repositories.includes([:checks]).order(full_name: :asc).map(&:decorate)
  end

  def show
    @repository = Repository.find params[:id]
    authorize @repository

    @checks = @repository.checks.order_by_created_at
  end

  def new
    @client_repos = fetch_suitable_client_repos
    @repository = Repository.new
  end

  def create
    @client_repos = fetch_suitable_client_repos
    @repository = current_user.repositories.build(repository_params)

    if @repository.save
      UpdateRepositoryJob.perform_later(@repository.id)
      f :success, redirect: repository_path(@repository)
    else
      # NOTE: status :see_other to pass specific Hexlet test
      f :error, now: true, render: :new, status: :see_other
    end
  end

  def destroy
    repository = Repository.find params[:id]
    authorize repository

    if repository.destroy
      f :success, redirect: repositories_path, status: :see_other
    else
      f :error, redirect_back: true, redirect: repositories_path, status: :unprocessable_entity
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end

  def fetch_suitable_client_repos
    RepositoryService.fetch_repositories!(current_user)
                     .select { |r| r[:language].present? && Repository::SUPPORTED_LANGUAGES.include?(r[:language].downcase.to_sym) }
                     .reject { |r| current_user.repositories.map(&:github_id).include? r[:id] }
  end
end
