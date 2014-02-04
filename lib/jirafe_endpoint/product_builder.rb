module Jirafe
  class ProductBuilder
    class << self
      def build_product(payload)
        {
          'id'          => payload['id'].to_s,
          'code'        => payload['sku'],
          'create_date' => payload['updated_at'],
          'change_date' => payload['updated_at'],
          'is_product'  => true,
          'is_sku'      => true
        }
      end
    end
  end
end
