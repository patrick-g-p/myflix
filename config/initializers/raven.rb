require 'raven'

Raven.configure do |config|
  config.dsn = ENV["RS_DSN"]
end
