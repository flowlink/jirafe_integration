source 'https://rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'capistrano'

gem 'httparty'

group :test do
  gem 'vcr'
  gem 'rspec', '= 2.13.0'
  gem 'webmock', '= 1.11.0'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
  gem 'simplecov', require: false
  gem 'pry'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

group :development do
  gem 'shotgun'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
end

group :development, :test do
  gem 'pry-byebug'
end

gem 'endpoint_base', github: 'spree/endpoint_base'
  # :path => '../endpoint_base'
gem 'honeybadger'
