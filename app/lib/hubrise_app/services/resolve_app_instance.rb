class HubriseApp::Services::ResolveAppInstance
  def self.run(scope, id, _ctx)
    scope.where(hr_id: id).take
  end
end
