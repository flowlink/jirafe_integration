module Jirafe
  module HashHelpers
    def items_hash(payload)
      payload['original']['line_items'].each_with_index.map do |line_item, i|
        {
          'id' => line_item['id'].to_s,
          'create_date' => line_item['created_at'],
          'change_date' => line_item['updated_at'],
          'status' => 'accepted',
          'discount_price' => 0,
          'order_item_number' => i.to_s,
          'cart_item_number' => i.to_s,
          'quantity' => line_item['quantity'],
          'price' => line_item['price'].to_f,
          'product' => {
            'id' => line_item['variant']['product_id'].to_s,
            'create_date' => line_item['variant']['product_created_at'],
            'change_date' => line_item['variant']['product_updated_at'],
            'is_product' => true,
            'is_sku' => true,
            'name' => line_item['variant']['name'],
            'code' => line_item['variant']['sku'],
            'categories' => categories_hash(line_item['variant']['product'])
          }
        }
      end
    end

    def customer_hash(payload, payload_type)
      {
        'id' => payload['original']['user_id'].to_s,
        'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        'email' => payload[payload_type]['email']
      }
    end

    def visit_hash(payload)
      {
        'visit_id' => payload['original']['visit_id'].to_s,
        'visitor_id' => payload['original']['visitor_id'].to_s,
        'pageview_id' => payload['original']['pageview_id'].to_s,
        'last_pageview_id' => payload['original']['last_pageview_id'].to_s
      }
    end

    def categories_hash(product_payload)
      product_payload['taxons'].map do |taxon|
        {
          'id' => taxon['id'].to_s,
          'name' => taxon['name']
        }
      end
    end

    module_function :items_hash, :customer_hash, :visit_hash, :categories_hash
  end
end
