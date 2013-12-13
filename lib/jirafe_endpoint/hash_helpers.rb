module Jirafe
  module HashHelpers
    def items_hash(payload)
      payload['original']['line_items'].each_with_index.map do |line_item, i|
        {
          'id' => line_item['id'].to_s,
          'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'status' => 'accepted',
          'discount_price' => 0,
          'order_item_number' => i.to_s,
          'cart_item_number' => i.to_s,
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

    def visit_hash(payload)
      {
        'visit_id' => payload['original']['visit_id'],
        'visitor_id' => payload['original']['visitor_id'],
        'pageview_id' => payload['original']['pageview_id'],
        'last_pageview_id' => payload['original']['last_pageview_id']
      }
    end
  end
end
