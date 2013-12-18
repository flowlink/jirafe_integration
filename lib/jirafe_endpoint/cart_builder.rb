module Jirafe
  class CartBuilder
    extend Jirafe::HashHelpers

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
