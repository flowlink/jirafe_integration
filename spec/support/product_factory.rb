module Factories
  def self.product(sku = 'ROR-TS')
    {
      "id"=> 12345,
      "name"=> "Ruby on Rails T-Shirt",
      "description"=> "Some description text for the product.",
      "sku"=> sku,
      "price"=> 31,
      "updated_at" => "2014-02-03T19:22:54.386Z",
      "properties"=> {
        "fabric"=> "cotton",
      },
      "options"=> [ "color", "size" ],
      "variants"=> [
        {
          "name"=> "Ruby on Rails T-Shirt S",
          "sku"=> "#{sku}-small",
          "options"=> {
            "size"=> "small",
            "color"=> "white"
          },
        },
        {
          "name"=> "Ruby on Rails T-Shirt M",
          "sku"=> "#{sku}-medium",
          "options"=> {
            "size"=> "medium",
            "color"=> "black"
          },
        }
      ],
    }
  end
end
