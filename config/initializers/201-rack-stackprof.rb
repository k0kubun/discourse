if ENV['STACKPROF_ENABLE'] == 'true'
  Rails.application.middleware.use(
    Rack::Stackprof,
    profile_interval_seconds: 0.05,
    sampling_interval_microseconds: 50,
    result_directory: 'tmp',
  )
end
