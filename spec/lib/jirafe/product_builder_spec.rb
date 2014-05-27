require 'spec_helper'

describe Jirafe::ProductBuilder do
  subject do
    Jirafe::ProductBuilder

  end
  let(:payload) do
    Factories.product.merge(Factories.parameters)
  end

  describe '.build' do
    before(:each) { @result = subject.new(payload).build }

    it 'returns an array' do
      @result.should be_a Array
    end

    it 'returns the right id and sku attributes' do
      @result.first['id'].should == payload['sku'].to_s
      @result.first['code'].should == payload['sku']
    end

    it 'returns the right date attributes' do
      @result.first['create_date'].should == payload['updated_at']
      @result.first['change_date'].should == payload['updated_at']
    end

    it 'returns a product for the original product and each variant' do
      @result.length.should == 3
    end
  end
end
