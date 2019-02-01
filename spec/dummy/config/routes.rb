Rails.application.routes.draw do
  root "application#open", as: :hubrise_open

  namespace :hubrise_oauth, path: "hubrise", controller: "/hubrise_app/oauth" do
    get :connect_callback
    get :login_callback
    get :authorize_callback
  end
end
