Interview::Application.routes.draw do

  match "hotel_recommendations/" => "hotel_recommendations#index"
  match "hotel_recommendations/show" => "hotel_recommendations#show"

  root :to => 'welcome#index'

  resources :hotels
  resources :members
  resources :hotel_stays
  resources :hotel_reviews

end
