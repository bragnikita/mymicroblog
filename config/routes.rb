Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  controller :posts do
    get '/p/:slug', action: :display
    get '/posts', action: :index
    get '/post/:id/edit', action: :edit
    get '/posts/new', action: :new
    get '/post/:id', action: :get
    post '/post/:id/update', action: :update
    post '/posts/create', action: :create
  end

  controller :images do
    get '/images', action: :index
    put '/images', action: :add
    delete '/image/:id', action: :destroy
  end

  controller :folders do
    get '/folders', action: :index
    post '/folder/:id', action: :update
    put '/folders', action: :create
    delete '/folder/:id', action: :destroy
  end

end
