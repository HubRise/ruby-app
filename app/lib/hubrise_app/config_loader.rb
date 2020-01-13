class HubriseApp::ConfigLoader
  def self.load
    Rails.application.config_for("hubrise_app/config").deep_symbolize_keys
  end
end
