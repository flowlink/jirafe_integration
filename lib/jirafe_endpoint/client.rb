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
      cart_hash           = Jirafe::CartBuilder.build_cart(payload, 'order')
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
      validate_batch_response(response)
    end

    def send_updated_order(payload)
      order_accepted_hash = Jirafe::OrderBuilder.order_accepted(payload)

      options = {
        headers: headers,
        body: order_accepted_hash.to_json
      }

      response = self.class.post('/order', options)
      validate_response(response)
    end

    def send_cart(payload)
      cart_hash = Jirafe::CartBuilder.build_cart(payload, 'cart')

      options = {
        headers: headers,
        body: cart_hash.to_json
      }

      response = self.class.post('/cart', options)
      validate_response(response)
    end

    def send_category(payload, taxonomy_id)
      return false unless taxonomy_id == payload['taxon']['taxonomy_id'].to_s

      category_hash = Jirafe::CategoryBuilder.build_category(payload)

      options = {
        headers: headers,
        body: category_hash.to_json
      }

      response = self.class.post('/category', options)
      validate_response(response)
    end

    private

    def validate_batch_response(response)
      raise JirafeEndpointError, response if Jirafe::ErrorParser.batch_response_has_errors?(response)
      true
    end

    def validate_response(response)
      raise JirafeEndpointError, response if Jirafe::ErrorParser.response_has_errors?(response)
      true
    end
  end
end
