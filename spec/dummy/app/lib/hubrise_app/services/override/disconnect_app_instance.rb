module HubriseApp::Services::Override::DisconnectAppInstance
  class SomeOverride
    def self.run(*_); end
  end

  def run(*args)
    super
    SomeOverride.run(*args)
  end
end
