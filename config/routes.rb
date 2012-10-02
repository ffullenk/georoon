Georoom::Application.routes.draw do
  resources :locations

  root :to => "locations#index"
  
  match 'search' => 'locations#search', :as => :search
  match 'buscar' => 'locations#buscar', :as => :buscar
end
