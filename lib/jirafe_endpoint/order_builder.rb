module Jirafe
  class OrderBuilder
    class << self
      def order_placed(payload)
        {
          'order_number' => payload['order']['number'],
          'status' => 'placed',
          'order_date' => payload['order']['placed_on'],
          'customer' => customer_hash(payload),
          'visit' => {
            'visit_id' => payload['original']['visit_id'],
            'visitor_id' => payload['original']['visitor_id'],
            'pageview_id' => payload['original']['pageview_id'],
            'last_pageview_id' => payload['original']['last_pageview_id']
          }
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
          'customer' => customer_hash(payload)
        })
      end

      private

      def customer_hash(payload)
        {
          'id' => payload['original']['user_id'],
          'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'email' => payload['order']['email'],
          'first_name' => payload['order']['billing_address']['firstname'],
          'last_name' => payload['order']['billing_address']['lastname']
        }
      end

      def items_hash(payload)
        payload['original']['line_items'].each_with_index.map do |line_item, i|
          {
            'id' => line_item['id'].to_s,
            'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
            'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
            'status' => 'accepted',
            'discount_price' => 0,
            'order_item_number' => i.to_s,
            'quantity' => line_item['quantity'],
            'price' => line_item['price'].to_f,
            'product' => {
              'id' => line_item['variant']['product_id'].to_s,
              'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
              'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
              'is_product' => true,
              'is_sku' => true,
              'name' => line_item['variant']['name'],
              'code' => line_item['variant']['sku']
            }
          }
        end
      end
    end
  end
end
