ActionController::Routing::Routes.draw do |map|
  map.resources :categories

  map.resources :dishes
  map.root :controller => :dishes, :action => :index
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
