source 'https://rubygems.org'
ruby '2.1.6'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem 'bootstrap_form'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'unicorn'
gem 'carrierwave'
gem 'mini_magick'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'rspec-rails', '2.99'
  gem 'capybara'
  gem 'capybara-email'
end

group :staging, :production do
  gem 'carrierwave-aws'
end

group :production do
  gem 'rails_12factor'
  gem 'sentry-raven'
end
