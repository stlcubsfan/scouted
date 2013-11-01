Scouted::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  namespace "api" do
    resources "stock_scouter" do
      member do
        get 'currentStockInfo'
      end
    end
    resource "positions" do
      collection do
        get "open_positions"
        get "closed_positions"
      end
    end
  end

  get '/templates/:path.html' => 'templates#template', :constraints => {:path => /.+/}
end