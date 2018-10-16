Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  controller :posts do
    get '/p/:slug', action: :display
    get '/posts', action: :index
    get '/posts/new', action: :new
  end

end
