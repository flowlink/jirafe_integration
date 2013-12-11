module Jirafe
  class Client
    attr_reader :site_id, :access_token

    def initialize(site_id, access_token)
      @site_id = site_id
      @access_token = access_token
    end

    def send_new_order(payload)
      true
    end
  end
end
