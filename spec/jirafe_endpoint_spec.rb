require 'spec_helper'

describe JirafeEndpoint do
  def app
    JirafeEndpoint
  end

  def auth
    {'HTTP_X_AUGURY_TOKEN' => '6a204bd89f3c8348afd5c77c717a097a', "CONTENT_TYPE" => "application/json"}
  end

  let(:order) { Factories.order }
  let(:original) { Factories.original }
  let(:params) { Factories.parameters }

  describe '/add_order' do
    context 'success' do
      it 'imports new orders' do
        message = {
          request_id: '123456',
          order: order,
          parameters: params
        }.to_json

        VCR.use_cassette('import_new_order') do
          post '/add_order', message, auth
          last_response.status.should == 200
          last_response.body.should match /was sent to Jirafe/
        end
      end
    end

    context 'failure' do
      it 'returns error details 'do
        order = Factories.order.merge({ :number => nil })

        message = {
          request_id: '123456',
          order: order,
          parameters: params
        }.to_json

        VCR.use_cassette('import_order_fail') do
          post '/add_order', message, auth
          last_response.status.should == 500
          last_response.body.should match /None is not of type/
        end
      end
    end
  end

  describe '/update_order' do
    context 'success' do
      it 'imports updated orders' do
        Jirafe::Client.any_instance.should_receive(:send_updated_order)

        message = {
          request_id: '123456',
          order: order,
          diff: original,
          parameters: params
        }.to_json

        VCR.use_cassette('import_updated_order') do
          post '/update_order', message, auth
          last_response.status.should == 200
          last_response.body.should match /was updated on Jirafe/
        end
      end

      it 'imports canceled orders' do
        Jirafe::Client.any_instance.should_receive(:send_canceled_order)

        order = Factories.order.merge(status: 'canceled')

        message = {
          request_id: '123456',
          order: order,
          diff: original,
          parameters: params
        }.to_json

        VCR.use_cassette('import_canceled_order') do
          post '/update_order', message, auth
          last_response.status.should == 200
          last_response.body.should match /was canceled on Jirafe/
        end
      end
    end
  end

  describe '/add_cart' do
    context 'success' do
      it 'imports carts' do
        message = {
          request_id: '123456',
          parameters: params,
          cart: order
        }.to_json

        VCR.use_cassette('import_new_cart') do
          post '/add_cart', message, auth
          last_response.status.should == 200
          last_response.body.should match /was sent to Jirafe/
        end
      end
    end

    context 'failure' do
      order = Factories.order
      order['placed_on'] = nil

      it 'returns error details' do
        message = {
          request_id: '123456',
          cart: order,
          parameters: params
        }.to_json

        VCR.use_cassette('import_new_cart_fail') do
          post '/add_cart', message, auth
          last_response.status.should == 500
          last_response.body.should match /None is not of type/
        end
      end
    end
  end

  describe '/add_product' do
    context 'success' do
      it 'imports a product' do
        message = {
          request_id: '123456',
          parameters: params,
          product: Factories.product
        }.to_json

        VCR.use_cassette('import_new_product') do
          post '/add_product', message, auth
          last_response.status.should == 200
          last_response.body.should match /was sent to Jirafe/
        end
      end
    end

    context 'failure' do
      product = Factories.order
      product['id'] = nil

      it 'returns error details' do
        message = {
          message_id: '123456',
          parameters: params,
          product: product
        }.to_json

        VCR.use_cassette('import_new_product_fail') do
          post '/add_product', message, auth
          last_response.status.should == 500
          last_response.body.should match /None is not of type/
        end
      end
    end
  end
end
