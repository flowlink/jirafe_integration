Dir['./lib/**/*.rb'].each { |f| require f }

class JirafeEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  before do
    @client = Jirafe::Client.new(@config['jirafe.site_id'], @config['jirafe.access_token'])
  end

  post '/import_new_order' do
    begin
      @client.send_new_order(@message[:payload])
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end
end
