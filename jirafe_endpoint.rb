Dir['./lib/**/*.rb'].each { |f| require f }

class JirafeEndpoint < EndpointBase::Sinatra::Base
end
