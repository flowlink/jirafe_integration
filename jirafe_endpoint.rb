require_relative './lib/jirafe_endpoint'

class JirafeEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/import_new_order' do
    begin
      client = Jirafe::Client.new(@config['jirafe.site_id'], @config['jirafe.access_token'])
      response = client.send_new_order(@message[:payload])
      code = 200

      cart_notification(@message)
      add_notification 'info', 'Order placed event sent to Jirafe',
        "An order-placed event for #{@message[:payload]['order']['number']} was sent to Jirafe."
      add_notification 'info', 'Order accepted event sent to Jirafe',
        "An order-accepted event for #{@message[:payload]['order']['number']} was sent to Jirafe."
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/import_cart' do
    begin
      client = Jirafe::Client.new(@config['jirafe.site_id'], @config['jirafe.access_token'])
      response = client.send_cart(@message[:payload])
      code = 200

      cart_notification(@message)
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  def error_notification(error)
    add_notification 'error', 'A Jirafe Endpoint error has occured', error.message
  end

  def cart_notification(message)
    add_notification 'info', 'Cart event sent to Jirafe',
      "A cart event for #{message[:payload]['order']['number']} was sent to Jirafe."
  end
end
