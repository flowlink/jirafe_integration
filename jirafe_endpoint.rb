require_relative './lib/jirafe_endpoint'

class JirafeEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/add_order' do
    begin
      client = Jirafe::Client.new(@payload['parameters']['jirafe_site_id'], @payload['parameters']['jirafe_access_token'])
      @payload[:order].merge!(@payload['parameters'])

      response = client.send_new_order(@payload[:order])

      code = 200
      set_summary "The order #{@payload[:order][:number]} was sent to Jirafe."
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/update_order' do
    begin
      client = Jirafe::Client.new(@payload['parameters']['jirafe_site_id'], @payload['parameters']['jirafe_access_token'])
      @payload[:order].merge!(@payload['parameters'])
      order_state = @payload[:order][:status]

      if @payload[:order][:status] != 'canceled'
        response = client.send_updated_order(@payload[:order])
        set_summary "The order #{@payload[:order][:number]} was updated on Jirafe."
      else
        response = client.send_canceled_order(@payload[:order])
        set_summary "The order #{@payload[:order][:number]} was canceled on Jirafe."
      end
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/add_cart' do
    begin
      client = Jirafe::Client.new(@payload['parameters']['jirafe_site_id'], @payload['parameters']['jirafe_access_token'])
      response = client.send_cart(@payload[:cart].merge(@payload['parameters']))
      code = 200

      set_summary "A cart event for #{@payload[:cart]} was sent to Jirafe."
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/update_cart' do
    begin
      client = Jirafe::Client.new(@payload['parameters']['jirafe_site_id'], @payload['parameters']['jirafe_access_token'])
      response = client.send_cart(@payload[:cart].merge(@payload['parameters']))
      code = 200

      set_summary "A cart event for #{@payload[:cart]} was sent to Jirafe."
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/add_product' do
    begin
      client = Jirafe::Client.new(@payload['parameters']['jirafe_site_id'], @payload['parameters']['jirafe_access_token'])
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
end
