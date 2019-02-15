Rails.application.routes.draw do
  get :hubrise_open, to: "application#open"
  mount HubriseApp::Engine => "/"
end
