class HubriseApp::Services::HandleEvent
  class << self
    def run(hr_app_instance, params)
      case params['resource_type']
      when 'customer'
        handle_customer_event(params)
      when 'order'
        handle_order_event(params)
      else
        raise 'Cannot handle hubrise event with type: ' + params['resource_type']
      end
    end

    protected

    def handle_customer_event(params);  end
    def handle_order_event(params);     end
  end
end

HubriseApp::Services::HandleEvent.include(HubriseApp::Services::Override::HandleEvent)
