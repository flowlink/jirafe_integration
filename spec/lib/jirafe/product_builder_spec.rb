require 'spec_helper'

describe Jirafe::ProductBuilder do
  let(:payload) do
    Factories.product
  end

  describe '.build_product' do
    before(:each) { @result = subject.class.build_product(payload) }

    it 'returns the right id and sku attributes' do
      @result['id'].should == payload['id']
      @result['code'].should == payload['sku']
    end

    it 'returns the right date attributes' do
      @result['create_date'].should == payload['updated_at']
      @result['change_date'].should == payload['updated_at']
    end
  end
end
