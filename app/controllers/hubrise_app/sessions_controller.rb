module HubriseApp
  class SessionsController < ApplicationController
    before_action :ensure_authenticated!

    def destroy
      logout
    end
  end
end
