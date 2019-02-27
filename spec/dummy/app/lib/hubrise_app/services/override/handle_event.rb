module HubriseApp::Services::Override::HandleEvent
  class SomeOverride
    def self.customer(*_); end
    def self.order(*_); end
  end

  protected
    def handle_customer_event(*args)
      SomeOverride.customer(*args)
    end

    def handle_order_event(*args)
      SomeOverride.order(*args)
    end
end
