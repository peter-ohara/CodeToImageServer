Rails.application.routes.draw do
  get '/convert', to: 'welcome#index'
  post '/change', to: 'conversion#convert'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
