HubriseApp::Engine.routes.draw do
  namespace :oauth_callback do
    get :connect
    get :authorize
    get :login
  end
end
