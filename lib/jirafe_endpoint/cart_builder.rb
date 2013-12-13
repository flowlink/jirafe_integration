module Jirafe
  class CartBuilder
    extend Jirafe::HashHelpers

    class << self
      def build_cart(payload)
        {
          'id' => payload['order']['number'],
          'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'subtotal' => payload['order']['totals']['item'],
          'total' => payload['order']['totals']['order'],
          'total_tax' => payload['order']['totals']['tax'],
          'total_shipping' => payload['order']['totals']['shipping'],
          'total_payment_cost' => payload['order']['totals']['payment'],
          'total_discounts' => 0,
          'currency' => payload['order']['currency'],
          'items' => items_hash(payload),
          'customer' => customer_hash(payload),
          'visit' => visit_hash(payload)
        }
      end
    end
  end
end
