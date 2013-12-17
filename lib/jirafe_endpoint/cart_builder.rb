module Jirafe
  class CartBuilder
    extend Jirafe::HashHelpers

    class << self
      def build_cart(payload, payload_type)
        {
          'id' => "C#{payload[payload_type]['number']}",
          'create_date' => payload['original']['created_at'],
          'change_date' => payload['original']['updated_at'],
          'subtotal' => payload[payload_type]['totals']['item'],
          'total' => payload[payload_type]['totals']['order'],
          'total_tax' => payload[payload_type]['totals']['tax'],
          'total_shipping' => payload[payload_type]['totals']['shipping'],
          'total_payment_cost' => payload[payload_type]['totals']['payment'],
          'total_discounts' => 0,
          'currency' => payload[payload_type]['currency'],
          'items' => items_hash(payload),
          'customer' => customer_hash(payload, payload_type),
          'visit' => visit_hash(payload)
        }
      end
    end
  end
end
