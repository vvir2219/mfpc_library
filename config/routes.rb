Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/', defaults: { format: :json } do
    resources :books, only: [ :index, :create, :show, :destroy] do
      collection do
        get '/available' => 'books#available_books'
        get '/search'    => 'books#search'
      end
    end

    resources :members, only: [ :index, :show, :create ] do
      member do
        get '/borrows' => 'members#borrows'
      end
    end

    resources :borrows, only: [ :index, :create ] do
      member do
        post '/return' => 'borrows#return_book'
      end
    end

  end
end
