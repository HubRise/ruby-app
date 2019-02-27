module HubriseApp::Services::Override::ConnectAppInstance
  class SomeOverride
    def self.run(*_); end
  end

  def run(*args)
    super
    SomeOverride.run(*args)
  end
end
