class HubriseApp::Services::ResolveAppInstance
  def self.run(scope, id, _ctx)
    scope.where(hr_id: id).includes(:hr_account, :hr_location).take
  end
end
