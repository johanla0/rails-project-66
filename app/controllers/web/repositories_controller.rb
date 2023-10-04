# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user
  before_action :fetch_client_repos, only: %i[new create]

  def index
    authorize(Repository)

    @repositories = current_user.repositories.includes([:checks]).order(full_name: :asc).map(&:decorate)
  end

  def show
    @repository = Repository.find params[:id]
    authorize @repository
  end

  def new
    authorize(Repository)

    @repository = Repository.new
  end

  def create
    authorize(Repository)

    @repository = RepositoryService.create!(current_user, repository_params)
    if @repository.valid?
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

  def fetch_client_repos
    @client_repos = UserService.fetch_repositories!(current_user)
  end
end
