require 'spec_helper'

describe Jirafe::CategoryBuilder do
  let(:taxon) { Factories.taxon }
  let(:payload) { { 'taxon' => Factories.taxon } }

  describe '.build_category' do
    it 'returns the right attributes' do
      result = subject.class.build_category(payload)
      result['id'].should == taxon['id'].to_s
      result['name'].should == taxon['name']
      result['create_date'].should == taxon['created_at']
      result['change_date'].should == taxon['updated_at']
    end
  end
end
