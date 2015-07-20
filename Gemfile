source 'https://rubygems.org'
ruby '2.1.6'

gem 'rails', '4.1.1'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'haml-rails'

gem 'coffee-rails'
gem 'uglifier'
gem 'jquery-rails'

gem 'pg'
gem 'bcrypt'
gem 'sidekiq'
gem 'sentry-raven'
gem 'stripe'
gem 'stripe_event'
gem 'figaro'
gem 'draper'

gem 'faker'
gem 'fabrication'

gem 'carrierwave'
gem 'mini_magick'
gem 'carrierwave-aws'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production, :staging do
  gem 'unicorn'
  gem 'rails_12factor'
end
