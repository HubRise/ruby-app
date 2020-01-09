module HubriseApp
  class ApplicationController < ActionController::Base
    include AppInstanceMethods
    include HubriseGatewayMethods
    include SessionMethods
  end
end
