Scouted::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  namespace "api" do
    resources "stock_scouter", :only => [:index]
  end

  get '/templates/:path.html' => 'templates#template', :constraints => {:path => /.+/}
end