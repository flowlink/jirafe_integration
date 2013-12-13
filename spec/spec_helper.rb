require 'bundler'
require 'rubygems'

Bundler.require(:default, :test)

require_relative '../jirafe_endpoint.rb'
require 'support/order_factory.rb'
require 'support/parameters_factory.rb'

Sinatra::Base.environment = 'test'

def app
  JirafeEndpoint
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

ENV['ENDPOINT_KEY'] = '6a204bd89f3c8348afd5c77c717a097a'

VCR.configure do |c|
  #c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end
