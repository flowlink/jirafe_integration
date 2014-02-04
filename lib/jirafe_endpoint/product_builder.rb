module Jirafe
  class ProductBuilder
    class << self
      def build_product(payload)
        {
          'id' => payload['id'],
          'code' => payload['sku'],
          'create_date' => payload['updated_at'],
          'change_date' => payload['updated_at']
        }
      end
    end
  end
end
