# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    @check = Repository::Check.find params[:id]
    @issues = JSON.parse(@check.issues)['lines'] if @check.issues.present?
  end
end
