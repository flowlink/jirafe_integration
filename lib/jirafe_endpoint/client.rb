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
      cart_hash           = Jirafe::CartBuilder.build_cart(payload)
      order_placed_hash   = Jirafe::OrderBuilder.order_placed(payload)
      order_accepted_hash = Jirafe::OrderBuilder.order_accepted(payload)

      options = {
        headers: headers,
        body: {
          :cart  => [
            cart_hash
          ],
          :order => [
            order_placed_hash,
            order_accepted_hash
          ]
        }.to_json
      }

      response = self.class.post('/batch', options)
      validate_response(response)
    end

    private

    def validate_response(response)
      if Jirafe::ErrorParser.batch_response_has_errors?(response)
        raise JirafeEndpointError, response
      end
      true
    end
  end
end
