module Jirafe
  class CategoryBuilder
    class << self
      def build_category(payload)
        {
          'id' => payload['taxon']['id'].to_s,
          'name' => payload['taxon']['name'],
          'create_date' => payload['taxon']['created_at'],
          'change_date' => payload['taxon']['updated_at']
        }
      end
    end
  end
end
