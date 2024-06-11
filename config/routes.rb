Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  
  devise_for :admins, controllers: {
    sessions: 'admin/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
    get "search" => "searches#search"
    
    scope module: :public do
    root 'homes#top'
    get '/about' => 'homes#about'
    resources :users, only: [:edit, :show, :update, :destroy]
    resources :posts, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      resources :favorites, only: [:index, :create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :tags, only: [:index, :show]
    
    #resources :relationships, only: [:index, :create, :destroy] 不要だと思われる
  end
  
    scope module: :admin do
    get '/' => 'homes#top'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :posts, only: [:index, :show, :edit, :update, :destroy]
    resources :tags, only: [:index, :create, :edit, :update, :destroy]
    get "search" => "searches#search"
  end
end
