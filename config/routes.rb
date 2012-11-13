Georoom::Application.routes.draw do
  devise_for :users

  resources :locations
  resources :places

  root :to => "locations#index"
  
  match 'search' => 'locations#search', :as => :search
  match 'buscar' => 'locations#buscar', :as => :buscar
  match '/auth/:provider/callback' => 'authentications#create'
end
