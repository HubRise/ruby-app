module HubriseApp::Override::HrUser
  extend ActiveSupport::Concern

  included do
    has_many :foo_app_instances, class_name: "HubriseApp::HrAppInstance", foreign_key: :hr_id
  end

  def foo
    :foo
  end
end
