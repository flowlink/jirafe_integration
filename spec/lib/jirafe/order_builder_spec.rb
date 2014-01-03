require 'spec_helper'

describe Jirafe::OrderBuilder do
  let(:payload) do
    {
      'order' => Factories.order,
      'original' => Factories.original,
      'brand_category_taxonomy' => '3'
    }
  end

  describe '.order_placed' do
    before(:each) { @result = subject.class.order_placed(payload) }

    it 'returns the right attributes' do
      @result['order_number'].should == payload['order']['number']
      @result['status'].should == 'placed'
      @result['order_date'].should == payload['order']['placed_on']
    end

    it 'returns the right customer attributes' do
      @result['customer'].should == Jirafe::HashHelpers.order_customer_hash(payload)
    end

    it 'returns the right visit attributes' do
      @result['visit'].should == Jirafe::HashHelpers.visit_hash(payload)
    end
  end

  describe '.order_accepted' do
    before(:each) { @result = subject.class.order_accepted(payload) }

    it 'returns the right items attributes' do
      @result['items'].should == Jirafe::HashHelpers.items_hash(payload)
    end

    it 'returns the right customer attributes' do
      @result['customer'].should == Jirafe::HashHelpers.order_customer_hash(payload)
    end

    it 'returns the right visit attributes' do
      @result['visit'].should == Jirafe::HashHelpers.visit_hash(payload)
    end

    it 'returns product brands' do
      @result['items'].first['product']['brand'].should == "Apache"
    end

    it 'returns the right total attributes' do
      @result['subtotal'].should == payload['order']['totals']['item'].to_f
      @result['total'].should == payload['order']['totals']['order'].to_f
      @result['total_tax'].should == payload['order']['totals']['tax'].to_f
      @result['total_shipping'].should == payload['order']['totals']['shipping'].to_f
      @result['total_payment_cost'].should == payload['order']['totals']['payment'].to_f
    end
  end
end
