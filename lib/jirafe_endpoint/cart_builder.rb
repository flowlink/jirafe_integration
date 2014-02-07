module Jirafe
  class CartBuilder
    class << self
      def build_cart(payload, payload_type)
        {
          'id' => "C#{payload[payload_type]['number']}",
          'create_date' => payload['original']['created_at'],
          'change_date' => payload['original']['updated_at'],
          'subtotal' => payload['original']['item_total'].to_f,
          'total' => payload['original']['total'].to_f,
          'total_tax' => payload['original']['tax_total'].to_f,
          'total_shipping' => payload['original']['ship_total'].to_f,
          'total_payment_cost' => payload['original']['payment_total'].to_f,
          'total_discounts' => -payload['original']['adjustment_total'].to_f,
          'currency' => payload[payload_type]['currency'],
          'items' => HashHelpers.items_hash(payload),
          'customer' => HashHelpers.cart_customer_hash(payload),
          'visit' => HashHelpers.visit_hash(payload)
        }
      end
    end
  end
end
