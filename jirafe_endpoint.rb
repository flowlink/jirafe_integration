require_relative './lib/jirafe_endpoint'

class JirafeEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  before do
    @client = Jirafe::Client.new(@config['jirafe.site_id'], @config['jirafe.access_token'])
  end

  post '/import_new_order' do
    begin
      response = @client.send_new_order(@message[:payload])
      code = 200

      add_notification 'info', 'Order placed event sent to Jirafe',
        "An order-placed event for #{@message[:payload]['order']['number']} was sent to Jirafe."
      add_notification 'info', 'Order accepted event sent to Jirafe',
        "An order-accepted event for #{@message[:payload]['order']['number']} was sent to Jirafe."
    rescue => e
      code = 500
      # error_notification(e)
    end

    process_result code
  end
end
