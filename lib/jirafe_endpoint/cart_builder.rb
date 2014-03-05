module Jirafe
  class CartBuilder
    class << self
      def build_cart(payload)
        {
          'id' => payload['number'],
          'create_date' => payload['placed_on'],
          'change_date' => payload['updated_at'],
          'subtotal' => payload['item_total'].to_f,
          'total' => payload['totals']['order'].to_f,
          'total_tax' => payload['totals']['tax'].to_f,
          'total_shipping' => payload['totals']['shipping'].to_f,
          'total_payment_cost' => payload['totals']['payment'].to_f,
          'total_discounts' => 0,
          'currency' => payload['currency'],
          'items' => HashHelpers.items_hash(payload),
          'customer' => HashHelpers.cart_customer_hash(payload),
          'visit' => HashHelpers.visit_hash(payload)
        }
      end
    end
  end
end
