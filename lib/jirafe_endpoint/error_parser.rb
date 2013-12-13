module Jirafe
  class ErrorParser
    def self.batch_response_has_errors?(response)
      response.any? do |r|
        r.last[0].has_key?('errors')
      end
    end
  end
end
