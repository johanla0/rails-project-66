# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  RELEVANT_FIELDS = %i[full_name git_url language name ssh_url].freeze

  before_action :authenticate_user

  def index
    # @repositories = current_user.repositories
    @repositories = Repository.all
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def new
    authorize(Repository)

    @repository = Repository.new
    @client_repos = fetch_client_repos
  end

  def create
    authorize(Repository)

    @repository = current_user.repositories.build(repository_params)

    attrs = fetch_client_repos.find { |r| r.full_name == @repository.full_name }.to_h.slice(*RELEVANT_FIELDS)
    @repository.assign_attributes(attrs)

    if @repository.valid?
      @repository.save
      RepositoryService.check!(@repository)
      f :success, redirect: repository_path(@repository)
    else
      f :error, now: true, render: :new, status: :unprocessable_entity
    end
  end

  def destroy
    @repository = Repository.find repository[:id]

    RepositoryService.destroy!(@repository)
    f :success, redirect_back: true, redirect: repositories_path, status: :see_other
  end

  private

  def repository_params
    params.require(:repository).permit(:full_name)
  end

  def fetch_client_repos
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    client.repos
  end
end
