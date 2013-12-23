require 'spec_helper'

describe Jirafe::CartBuilder do
  let(:payload) do
    {
      'cart' => Factories.order,
      'original' => Factories.original
    }
  end

  describe '.build_cart' do
    before(:each) { @result = subject.class.build_cart(payload, 'cart') }

    it 'returns the right date attributes' do
      @result['create_date'].should == payload['original']['created_at']
      @result['change_date'].should == payload['original']['updated_at']
    end

    it 'returns the right total attributes' do
      @result['subtotal'].should == payload['original']['subtotal'].to_f
      @result['total'].should == payload['original']['total'].to_f
      @result['total_tax'].should == payload['original']['tax_total'].to_f
      @result['total_shipping'].should == payload['original']['ship_total'].to_f
      @result['total_payment_cost'].should == payload['original']['payment_total'].to_f
      @result['total_discounts'].should == payload['original']['adjustment_total'].to_f
    end

    it 'returns the right items attributes' do
      @result['items'].should == Jirafe::HashHelpers.items_hash(payload)
    end

    it 'returns the right customer attributes' do
      @result['customer'].should == Jirafe::HashHelpers.cart_customer_hash(payload)
    end

    it 'returns the right visit attributes' do
      @result['visit'].should == Jirafe::HashHelpers.visit_hash(payload)
    end
  end
end
