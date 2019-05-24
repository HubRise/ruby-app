class HubriseApp::Services::HandleEvent
  prepend HubriseApp::Services::Override::HandleEvent

  class << self; delegate :run, to: :new; end

  def run(hr_app_instance, params)
    case params["resource_type"]
    when "customer"
      handle_customer_event(hr_app_instance, params)
    when "order"
      handle_order_event(hr_app_instance, params)
    else
      raise "Cannot handle hubrise event with type: " + params["resource_type"].to_s
    end
  end

  protected

  def handle_customer_event(hr_app_instance, params);  end

  def handle_order_event(hr_app_instance, params);     end
end
