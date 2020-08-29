class User < HubriseApp::ApplicationRecord
  has_many :user_app_instances, -> { fresh }, primary_key: :hr_id, foreign_key: :hr_user_id
  has_many :app_instances, through: :user_app_instances

  serialize :locales

  def primary_locale
    locales.first
  end

  def full_name
    [first_name, last_name].join(" ")
  end
end
