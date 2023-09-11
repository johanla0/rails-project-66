# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://ff8ffe5a3189954dd90e6258e8589b42@o4505335392567296.ingest.sentry.io/4505812771012608'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.enabled_environments = %w[production]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
