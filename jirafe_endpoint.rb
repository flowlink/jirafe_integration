require_relative './lib/jirafe_endpoint'

class JirafeEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/import_order' do
    begin
      client = Jirafe::Client.new(@config['jirafe.site_id'], @config['jirafe.access_token'])
      payload = @message[:payload].merge('brand_category_taxonomy' => @config['jirafe.brand_category_taxonomy'],
                                         'product_category_taxonomy' => @config['jirafe.product_category_taxonomy'],
                                         'store_url' => @config['jirafe.store_url'])
      order_state = @message[:payload]['order']['status']

      if @message[:payload]['diff'].present? && order_state != 'canceled' # order:updated
        response = client.send_updated_order(payload)
        order_accepted_notification(@message)
      elsif order_state == 'canceled' # canceled order
        response = client.send_canceled_order(payload)
        add_notification 'info', 'Order canceled event sent to Jirafe',
          "An order-canceled event for #{payload['order']['number']} was sent to Jirafe."
      else # order:new
        response = client.send_new_order(payload)
        code = 200

        add_notification 'info', 'Cart event sent to Jirafe',
          "A cart event for #{payload['order']['number']} was sent to Jirafe."
        add_notification 'info', 'Order placed event sent to Jirafe',
          "An order-placed event for #{payload['order']['number']} was sent to Jirafe."
        order_accepted_notification(@message)
      end
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

      add_notification 'info', 'Cart event sent to Jirafe',
        "A cart event for #{@message[:payload]['cart']['number']} was sent to Jirafe."
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/add_product' do
    begin
      client = Jirafe::Client.new(@payload['parameters']['jirafe.site_id'], @payload['parameters']['jirafe.access_token'])
      response = client.send_product(@payload[:product])
      code = 200

      set_summary "The product #{@payload[:product]['sku']} was sent to Jirafe."
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  def error_notification(error)
    set_summary "A Jirafe Endpoint error has occured: #{error.message} BACKTRACE: #{error.backtrace}"
  end

  def order_accepted_notification(message)
    add_notification 'info', 'Order accepted event sent to Jirafe',
      "An order-accepted event for #{message[:payload]['order']['number']} was sent to Jirafe."
  end
end
