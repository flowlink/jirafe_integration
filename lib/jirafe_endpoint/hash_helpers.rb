module Jirafe
  module HashHelpers
    def items_hash(payload)
      payload['line_items'].each_with_index.map do |line_item, i|
        hash = {
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
            'is_product' => true,
            'is_sku' => true,
            'name' => line_item['variant']['name'],
            'code' => line_item['variant']['sku'],
            'images' => determine_product_images(line_item['variant']['images'], payload['jirafe_store_url'])
          }
        }

        if line_item['variant']['product'].is_a? Hash
          product = {
            'create_date' => line_item['variant']['product']['created_at'],
            'change_date' => line_item['variant']['product']['updated_at'],
            'categories' => categories_hash(line_item['variant']['product']),
            'brand' => determine_product_brand(line_item['variant']['product'], payload['jirafe_brand_category_taxonomy']),
          }

          hash.merge! product
        end

        hash
      end
    end

    def cart_customer_hash(payload)
      {
        'id' => payload['user_id'].to_s || '',
        'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        'email' => payload['email'] || ''
      }
    end

    def order_customer_hash(payload)
      customer = {
        'id' => payload['user_id'].to_s,
        'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        'email' => payload['email']
      }

      if payload['billing_address'].is_a? Hash
        customer.merge!({
          'first_name' => payload['billing_address']['firstname'],
          'last_name' => payload['billing_address']['lastname']
        })
      end

      customer
    end

    def visit_hash(payload)
      {
        'visit_id' => payload['visit_id'].to_s,
        'visitor_id' => payload['visitor_id'].to_s,
        'pageview_id' => payload['pageview_id'].to_s,
        'last_pageview_id' => payload['last_pageview_id'].to_s
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

    def determine_product_brand(product_payload, brand_taxonomy_id)
      return '' unless brand_taxonomy_id
      result = product_payload['taxons'].detect { |taxon| taxon['taxonomy_id'] == brand_taxonomy_id.to_i }
      result ? result['name'] : ''
    end

    def determine_product_images(images_payload, store_url)
      return [] unless store_url

      result = []
      images_payload.each do |image|
        if image['attachment_url'].start_with?('http')
          url = image['attachment_url']
        else
          url = "#{store_url.sub(/(\/)+$/, '')}#{image['attachment_url']}"
        end
        result << { 'url' => url }
      end

      result
    end

    module_function :items_hash, :cart_customer_hash, :visit_hash, :categories_hash, :order_customer_hash, :determine_product_brand, :determine_product_images
  end
end
