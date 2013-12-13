require 'spec_helper'

describe JirafeEndpoint do
  def app
    JirafeEndpoint
  end

  def auth
    {'HTTP_X_AUGURY_TOKEN' => '6a204bd89f3c8348afd5c77c717a097a', "CONTENT_TYPE" => "application/json"}
  end

  describe '/import_new_order' do
    context 'success' do
      it 'imports new orders' do
        order = Factories.order
        original = Factories.original
        params = Factories.parameters

        message = {
          message_id: '123456',
          message: 'order:new',
          payload: {
            order: order,
            original: original,
            parameters: params
          }
        }.to_json

        VCR.use_cassette('import_new_order') do
          post '/import_new_order', message, auth
          last_response.status.should == 200
          last_response.body.should match /cart event/
          last_response.body.should match /order-placed event/
          last_response.body.should match /order-accepted event/
        end
      end
    end

    context 'failure' do
      it 'returns error details 'do
        order = Factories.order.merge({ :number => nil })
        original = Factories.original
        params = Factories.parameters

        message = {
          message_id: '123456',
          message: 'order:new',
          payload: {
            order: order,
            original: original,
            parameters: params
          }
        }.to_json

        VCR.use_cassette('import_new_order_fail') do
          post '/import_new_order', message, auth
          last_response.status.should == 500
          last_response.body.should match /None is not of type/
        end
      end
    end
  end
end
