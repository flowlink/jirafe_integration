require 'spec_helper'

describe Jirafe::CartBuilder do
  let(:payload) do
    Factories.order
  end

  describe '.build_cart' do
    before(:each) { @result = subject.class.build_cart(payload) }

    it 'returns the right date attributes' do
      @result['create_date'].should == payload['placed_on']
      @result['change_date'].should == payload['updated_at']
    end

    it 'returns the right total attributes' do
      @result['subtotal'].should == payload['subtotal'].to_f
      @result['total'].should == payload['totals']['order'].to_f
      @result['total_tax'].should == payload['totals']['tax'].to_f
      @result['total_shipping'].should == payload['totals']['shipping'].to_f
      @result['total_payment_cost'].should == payload['totals']['payment'].to_f
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
