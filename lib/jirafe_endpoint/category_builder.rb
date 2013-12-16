module Jirafe
  class CategoryBuilder
    class << self
      def build_category(payload)
        {
          'id' => payload['id'].to_s,
          'name' => payload['name'],
          'create_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
          'change_date' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
        }
      end
    end
  end
end
