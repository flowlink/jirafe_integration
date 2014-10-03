require 'spec_helper'

describe Jirafe::ProductBuilder do
  subject do
    Jirafe::ProductBuilder

  end
  let(:payload) do
    Factories.product.merge(Factories.parameters)
  end

  let(:payload_with_available_on) do
    Factories.product.merge(Factories.parameters).merge({'available_on' => '2014-02-03T15:00:54.386Z'})
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
      @result.first['create_date'].should == DateTime.parse(payload['created_at']).to_s
      @result.first['change_date'].should == DateTime.parse(payload['updated_at']).to_s
    end

    it 'returns the right date attributes with available_on' do
      result_with_available_on = subject.new(payload_with_available_on).build
      result_with_available_on.first['create_date'].should == DateTime.parse(payload_with_available_on['available_on']).to_s
      result_with_available_on.first['change_date'].should == DateTime.parse(payload_with_available_on['available_on']).to_s
    end

    it 'returns a product for the original product and each variant' do
      @result.length.should == 3
    end
  end
end
