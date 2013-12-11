require 'spec_helper'

describe JirafeEndpoint do
  def app
    JirafeEndpoint
  end

  def auth
    {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"}
  end
end
