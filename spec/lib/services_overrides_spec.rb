require "rails_helper"

RSpec.describe "services/override" do
  it "overrides ConnectAppInstance" do
    expect(HubriseApp::Services::Override::ConnectAppInstance::SomeOverride).to receive(:run).with(:arg1)
    HubriseApp::Services::ConnectAppInstance.run(:arg1)
  end

  it "overrides DisconnectAppInstance" do
    expect(HubriseApp::Services::Override::DisconnectAppInstance::SomeOverride).to receive(:run).with(:arg1)
    HubriseApp::Services::DisconnectAppInstance.run(:arg1)
  end

  it "overrides HandleEvent customer handler" do
    expect(HubriseApp::Services::Override::HandleEvent::SomeOverride).to receive(:customer).with(:arg1, { "resource_type" => "customer" })
    HubriseApp::Services::HandleEvent.run(:arg1, { "resource_type" => "customer" })
  end

  it "overrides HandleEvent order handler" do
    expect(HubriseApp::Services::Override::HandleEvent::SomeOverride).to receive(:order).with(:arg1, { "resource_type" => "order" })
    HubriseApp::Services::HandleEvent.run(:arg1, { "resource_type" => "order" })
  end
end
