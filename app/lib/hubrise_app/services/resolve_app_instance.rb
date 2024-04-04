# frozen_string_literal: true
module HubriseApp
  module Services
    class ResolveAppInstance
      def self.run(scope, id, _ctx)
        scope.where(hr_id: id).take
      end
    end
  end
end
