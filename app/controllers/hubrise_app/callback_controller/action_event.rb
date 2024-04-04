# frozen_string_literal: true
module HubriseApp
  class CallbackController
    module ActionEvent
      def event
        head(200)
      end
    end
  end
end
