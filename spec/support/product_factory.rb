module Factories
  def self.product(sku = 'ROR-TS')
    {
      "name"=> "Ruby on Rails T-Shirt",
      "description"=> "Some description text for the product.",
      "sku"=> sku,
      "price"=> 31,
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
