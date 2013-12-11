module Factories
  def self.order(payment_method=nil)
    {
      "number" => "311174282",
      "channel" => "spree",
      "email" => "spree@example.com",
      "currency" => "USD",
      "placed_on" => "2013-07-30T19 =>19 =>05Z",
      "updated_at" => "2013-07-30T20 =>08 =>39Z",
      "status" => "complete",
      "totals" => {
          "item" => 99.95,
          "adjustment" => 15,
          "tax" => 5,
          "shipping" => 0,
          "payment" => 114.95,
          "order" => 114.95
      },
      "line_items" => [
          {
              "name" => "Spree Baseball Jersey",
              "sku" => "PNT-RED-28x30",
              "external_ref" => "",
              "quantity" => 2,
              "price" => 19.99,
              "variant_id" => 8,
              "options" => {}
          }
      ],
      "adjustments" => [
          {
              "name" => "Shipping",
              "value" => 5
          },
          {
              "name" => "Shipping",
              "value" => 5
          },
          {
              "name" => "North America 5.0%",
              "value" => 5
          }
      ],
      "shipping_address" => {
          "firstname" => "Brian",
          "lastname" => "Quinn",
          "address1" => "7735 Old Georgetown Rd",
          "address2" => " ",
          "zipcode" => "20814",
          "city" => "Bethesda",
          "state" => "MD",
          "country" => "US",
          "phone" => "555-123-456"
      },
      "billing_address" => {
          "firstname" => "Brian",
          "lastname" => "Quinn",
          "address1" => "7735 Old Georgetown Rd",
          "address2" => " ",
          "zipcode" => "20814",
          "city" => "Bethesda",
          "state" => "MD",
          "country" => "US",
          "phone" => "555-123-456"
      },
      "payments" => [
          {
              "number" => 6,
              "status" => "completed",
              "amount" => 5,
              "payment_method" => payment_method || 'credit card'
          }
      ],
      "shipments" => [
          {
              "number" => "H273910304",
              "cost" => 5,
              "status" => "shipped",
              "stock_location" => 'HQNYC',
              "shipping_method" => "UPS Ground (USD)",
              "tracking" => nil,
              "updated_at" => nil,
              "shipped_at" => "2013-07-30T20 =>08 =>38Z",
              "items" => [
                  {
                      "name" => "Spree Baseball Jersey",
                      "sku" => "SPR-00001",
                      "external_ref" => "",
                      "quantity" => 1,
                      "price" => 19.99,
                      "variant_id" => 8,
                      "options" => {}
                  },
                  {
                      "name" => "Ruby on Rails Baseball Jersey",
                      "sku" => "ROR-00004",
                      "external_ref" => "",
                      "quantity" => 1,
                      "price" => 19.99,
                      "variant_id" => 20,
                      "options" => {
                          "tshirt-color" => "Red",
                          "tshirt-size" => "Medium"
                      }
                  }
              ]
          },
          {
              "number" => "H982906499",
              "cost" => 5,
              "status" => "ready",
              "stock_location" => nil,
              "shipping_method" => "UPS Ground (USD)",
              "tracking" => "4532535354353452",
              "updated_at" => nil,
              "shipped_at" => nil,
              "items" => [
                  {
                      "name" => "Ruby on Rails Baseball Jersey",
                      "sku" => "ROR-00004",
                      "external_ref" => "",
                      "quantity" => 2,
                      "price" => 19.99,
                      "variant_id" => 20,
                      "options" => {
                          "tshirt-color" => "Red",
                          "tshirt-size" => "Medium"
                      }
                  },
                  {
                      "name" => "Spree Baseball Jersey",
                      "sku" => "SPR-00001",
                      "external_ref" => "",
                      "quantity" => 1,
                      "price" => 19.99,
                      "variant_id" => 8,
                      "options" => {}
                  }
              ]
          }
      ]
    }
  end

  def self.original
    {
      "credit_cards" => [
        "id" => 3,
        "month" => "11",
        "year" => "2013",
        "cc_type" => "visa"
      ],
      "shipments" => [
        {
          "stock_location_name" => "Something"
        }
      ]
    }
  end
end
