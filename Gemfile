source 'https://rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'capistrano'

gem 'httparty'

group :test do
  gem 'vcr'
  gem 'rspec', '= 2.11.0'
  gem 'webmock', '= 1.11.0'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

group :development do
  gem 'shotgun'
  gem 'pry'
end

gem 'endpoint_base', '~> 0.1.0'
  # :path => '../endpoint_base'
