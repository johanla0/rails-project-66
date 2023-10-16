# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'sidekiq/testing'

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }

OmniAuth.config.test_mode = true
Sidekiq::Testing.inline!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  teardown do
    Sidekiq::Job.clear_all
  end

  # Add more helper methods to be used by all tests here...
  def load_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationHelper
end
