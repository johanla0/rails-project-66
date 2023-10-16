# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 7.0.4', '>= 7.0.4.3'

gem 'aasm'
gem 'cssbundling-rails'
gem 'data_migrate'
gem 'dotenv-rails', '~> 2.8'
gem 'dry-container'
gem 'enumerize', '~> 2.7'
gem 'git'
gem 'jsbundling-rails'
gem 'octokit'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'puma', '~> 5.0'
gem 'pundit', '~> 2.3'
gem 'redis'
# NOTE: rubocop is used by the linter lib
gem 'rubocop', require: false
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'simple_form'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'term-ansicolor'
gem 'turbo-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'faker'
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'annotate', '~> 3.2'
  gem 'bullet', '~> 7.0'
  gem 'i18n-debug'
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false

  gem 'slim_lint', '~> 0.24.0'
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  # gem "capybara"
  # gem "selenium-webdriver"
  # gem "webdrivers"
  gem 'minitest-power_assert'
  gem 'webmock'
end

group :production do
  gem 'pg'
end
