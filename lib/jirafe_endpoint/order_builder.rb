module Jirafe
  class OrderBuilder
    class << self
      def order_placed(payload)
        {
          'order_number' => payload['order']['number'],
          'status' => 'placed',
          'order_date' => payload['order']['placed_on'],
          'customer' => {
            'id' => payload['original']['user_id'],
            'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
            'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
            'email' => payload['order']['email'],
            'first_name' => payload['order']['billing_address']['firstname'],
            'last_name' => payload['order']['billing_address']['lastname']
          },
          'visit' => {
            'visit_id' => payload['original']['visit_id'],
            'visitor_id' => payload['original']['visitor_id'],
            'pageview_id' => payload['original']['pageview_id'],
            'last_pageview_id' => payload['original']['last_pageview_id']
          }
        }.to_json
      end
    end
  end
end
