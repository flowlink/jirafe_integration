module Jirafe
  class Client
    include HTTParty

    attr_reader :site_id, :access_token, :headers

    def initialize(site_id, access_token)
      @site_id      = site_id
      @access_token = access_token
      @headers      = { "Authorization" => "Bearer #{access_token}", "Content-Type" => "application/json" }

      self.class.base_uri "https://event.jirafe.com/v2/#{site_id}"
    end

    def send_new_order(payload)
      order_placed_json = Jirafe::OrderBuilder.order_placed payload

      options = {
        headers: headers,
        body: order_placed_json
      }

      response = self.class.post('/order', options)
      validate_response(response)
    end

    private

    def validate_response(response)
      if response['success']
        true
      end
    end
  end
end
