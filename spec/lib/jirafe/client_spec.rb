require 'spec_helper'

describe Jirafe::Client do
  subject do
    Jirafe::Client.new('123', '123')
  end

  before(:each) do
    @payload ={
      'order' => Factories.order,
      'original' => Factories.original,
      'parameters' => Factories.parameters
    }
  end

  describe '#send_new_order' do
    before(:each) do
      Jirafe::CartBuilder.should_receive(:build_cart).and_call_original
      Jirafe::OrderBuilder.should_receive(:order_placed).at_least(:once).and_call_original
      Jirafe::OrderBuilder.should_receive(:order_accepted).and_call_original
    end

    context 'success' do
      it 'sends the order to jirafe' do
        VCR.use_cassette('import_new_order') do
          subject.send_new_order(@payload).should be_true
        end
      end
    end

    context 'failure' do
      it 'raises JirafeEndpointError' do
        @payload['order']['number'] = nil
        VCR.use_cassette('import_new_order_fail') do
          expect { subject.send_new_order(@payload) }.to raise_error(JirafeEndpointError)
        end
      end
    end
  end

  describe '#send_updated_order' do
    before(:each) do
      Jirafe::OrderBuilder.should_receive(:order_accepted).and_call_original
    end

    context 'success' do
      it 'sends the order to jirafe' do
        VCR.use_cassette('import_updated_order') do
          subject.send_updated_order(@payload).should be_true
        end
      end
    end

    context 'failure' do
      it 'raises JirafeEndpointError' do
        @payload['order']['number'] = nil
        VCR.use_cassette('import_updated_order_fail') do
          expect { subject.send_updated_order(@payload) }.to raise_error(JirafeEndpointError)
        end
      end
    end
  end

  describe '#send_canceled_order' do
    before(:each) do
      Jirafe::OrderBuilder.should_receive(:order_canceled).and_call_original
    end

    context 'success' do
      it 'sends the order to jirafe' do
        VCR.use_cassette('import_canceled_order') do
          subject.send_canceled_order(@payload).should be_true
        end
      end
    end
  end

  describe '#send_cart' do
    before(:each) do
      Jirafe::CartBuilder.should_receive(:build_cart).and_call_original
      @payload.merge!(Factories.order)
    end

    context 'success' do
      it 'sends the cart to jirafe' do
        VCR.use_cassette('import_cart') do
          subject.send_cart(@payload).should be_true
        end
      end
    end

    context 'failure' do
      it 'raises JirafeEndpointError' do
        @payload['placed_on'] = nil
        VCR.use_cassette('import_cart_fail') do
          expect { subject.send_cart(@payload) }.to raise_error(JirafeEndpointError)
        end
      end
    end
  end

  describe '#send_product' do
    before(:each) do
      Jirafe::ProductBuilder.should_receive(:build_product).and_call_original
      @payload = Factories.product
    end

    context 'success' do
      it 'sends the product to jirafe' do
        VCR.use_cassette('import_product') do
          subject.send_product(@payload).should be_true
        end
      end
    end
  end
end
