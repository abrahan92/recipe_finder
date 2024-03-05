Rails.application.routes.draw do
  get 'recipes/search', to: 'recipes#search'
  get 'ingredients/search', to: 'ingredients#search'
end
