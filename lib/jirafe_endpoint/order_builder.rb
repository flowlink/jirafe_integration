module Jirafe
  class OrderBuilder
    extend Jirafe::HashHelpers

    class << self
      def order_placed(payload)
        {
          'order_number' => payload['order']['number'],
          'status' => 'placed',
          'order_date' => payload['order']['placed_on'],
          'customer' => customer_hash(payload, 'order'),
          'visit' => visit_hash(payload)
        }
      end

      def order_accepted(payload)
        order_placed(payload).merge({
          'status' => 'accepted',
          'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'subtotal' => payload['order']['totals']['item'],
          'total' => payload['order']['totals']['order'],
          'total_tax' => payload['order']['totals']['tax'],
          'total_shipping' => payload['order']['totals']['shipping'],
          'total_payment_cost' => payload['order']['totals']['payment'],
          'total_discounts' => 0,
          'currency' => payload['order']['currency'],
          'delivery_address' => {
            'postalcode' => payload['order']['shipping_address']['zipcode'],
            'address1' => payload['order']['shipping_address']['address1'],
            'country' => payload['order']['shipping_address']['country'],
            'state' => payload['order']['shipping_address']['state'],
            'city' => payload['order']['shipping_address']['city']
          },
          'payment_address' => {
            'postalcode' => payload['order']['billing_address']['zipcode'],
            'address1' => payload['order']['billing_address']['address1'],
            'country' => payload['order']['billing_address']['country'],
            'state' => payload['order']['billing_address']['state'],
            'city' => payload['order']['billing_address']['city']
          },
          'items' => items_hash(payload),
          'customer' => customer_hash(payload, 'order')
        })
      end
    end
  end
end
