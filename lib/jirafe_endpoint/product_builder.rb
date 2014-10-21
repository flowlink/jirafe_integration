require 'pry'

module Jirafe
  class ProductBuilder
    attr_accessor :payload

    def initialize(payload)
      @payload = payload
    end

    def build
      if payload['variants'].present?
        build_with_variants
      else
        build_without_variants
      end
    end

    def build_without_variants
      product = {
        'id'          => payload['sku'].to_s,
        'code'        => payload['sku'],
        'create_date' => create_date(payload),
        'change_date' => change_date(payload),
        'is_product'  => true,
        'is_sku'      => true
      }
      product.merge!('categories' => HashHelpers.taxons_hash(payload)) if payload['meta_data']['jirafe']['taxons'].present?
      product.merge!('images' => HashHelpers.determine_product_images(payload['images'], payload['jirafe_store_url'] || nil)) if payload['images'].present?

      [product]
    end

    def build_with_variants
      base_product = build_without_variants
      result = [base_product]

      payload['variants'].each do |variant|
        product = {
          'create_date' => create_date(payload),
          'change_date' => change_date(payload),
          'id'          => variant['sku'],
          'code'        => variant['sku'],
          'is_product' => false,
          'is_sku'     => true,
          'base_product' => {
            'id'   => payload['sku'].to_s,
            'name' => payload['name'],
            'code' => payload['sku']
          }
        }
        result << product
      end
      result.flatten
    end

    def create_date(payload)
      return DateTime.parse(payload['available_on']).to_s if payload.key?('available_on') && payload['available_on']
      return DateTime.parse(payload['created_at']).to_s if payload.key?('created_at') && payload['created_at']
      DateTime.now.to_s
    end

    def change_date(payload)
      return DateTime.parse(payload['available_on']).to_s if payload.key?('available_on') && payload['available_on']
      return DateTime.parse(payload['updated_at']).to_s if payload.key?('updated_at') && payload['updated_at']
      DateTime.now.to_s
    end
  end
end
