module Jirafe
  class OrderBuilder
    class << self
      def order_placed(payload)
        {
          'order_number' => payload['number'],
          'status' => 'placed',
          'order_date' => payload['placed_on'],
          'customer' => HashHelpers.order_customer_hash(payload),
          'visit' => HashHelpers.visit_hash(payload)
        }
      end

      def order_canceled(payload)
        {
          'order_number' => payload['number'],
          'cancel_date' => payload['updated_at'],
          'status' => 'cancelled'
        }
      end

      def order_accepted(payload)
        data = {
          'status' => 'accepted',
          'create_date' => payload['placed_on'],
          'change_date' => payload['updated_at'],
          'total_discounts' => 0,
          'currency' => payload['currency'],
          'items' => HashHelpers.items_hash(payload),
          'customer' => HashHelpers.order_customer_hash(payload)
        }

        if payload['totals'].is_a? Hash
          data.merge!({
            'subtotal' => payload['totals']['item'].to_f,
            'total' => payload['totals']['order'].to_f,
            'total_tax' => payload['totals']['tax'].to_f,
            'total_shipping' => payload['totals']['shipping'].to_f,
            'total_payment_cost' => payload['totals']['payment'].to_f,
          })
        end

        if payload['shipping_address'].is_a? Hash
          data.merge!({
            'delivery_address' => {
              'postalcode' => payload['shipping_address']['zipcode'],
              'address1' => payload['shipping_address']['address1'],
              'country' => payload['shipping_address']['country'],
              'state' => payload['shipping_address']['state'],
              'city' => payload['shipping_address']['city']
            }
          })
        end

        if payload['billing_address'].is_a? Hash
          data.merge!({
          'payment_address' => {
            'postalcode' => payload['billing_address']['zipcode'],
            'address1' => payload['billing_address']['address1'],
            'country' => payload['billing_address']['country'],
            'state' => payload['billing_address']['state'],
            'city' => payload['billing_address']['city']
            }
          })
        end

        order_placed(payload).merge(data)
      end
    end
  end
end
