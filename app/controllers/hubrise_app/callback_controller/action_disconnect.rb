# frozen_string_literal: true
module HubriseApp
  class CallbackController
    module ActionDisconnect
      def disconnect
        head(200)
      end
    end
  end
end
