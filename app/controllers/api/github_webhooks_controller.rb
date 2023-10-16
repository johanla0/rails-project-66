# frozen_string_literal: true

class Api::GithubWebhooksController < Api::ApplicationController
  def checks
    case request.headers['X-GitHub-Event']
    when 'ping'
      render json: { message: 'pong' }, status: :ok
    when 'push', nil
      repository = Repository.find_by(github_id: repository_params[:id])
      return render(json: { error: 'not_found' }, status: :not_found) if repository.blank?

      return render(json: { error: 'conflict' }, status: :conflict) if repository.being_checked?

      CheckRepositoryJob.perform_async(repository.id)
      render json: { message: 'created' }, status: :ok
    else
      render json: { error: 'not_implemented' }, status: :not_implemented
    end
  end

  private

  def repository_params
    params.require('repository').permit('id')
  end
end
