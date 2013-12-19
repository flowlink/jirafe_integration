module Jirafe
  class OrderBuilder
    class << self
      def order_placed(payload)
        {
          'order_number' => payload['order']['number'],
          'status' => 'placed',
          'order_date' => payload['order']['placed_on'],
          'customer' => HashHelpers.customer_hash(payload, 'order'),
          'visit' => HashHelpers.visit_hash(payload)
        }
      end

      def order_accepted(payload)
        order_placed(payload).merge({
          'status' => 'accepted',
          'create_date' => payload['order']['placed_on'],
          'change_date' => payload['order']['updated_at'],
          'subtotal' => payload['order']['totals']['item'],
          'total' => payload['order']['totals']['order'].to_f,
          'total_tax' => payload['order']['totals']['tax'].to_f,
          'total_shipping' => payload['order']['totals']['shipping'].to_f,
          'total_payment_cost' => payload['order']['totals']['payment'].to_f,
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
          'items' => HashHelpers.items_hash(payload),
          'customer' => HashHelpers.customer_hash(payload, 'order')
        })
      end
    end
  end
end
