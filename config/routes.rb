Rails.application.routes.draw do

  # 管理者 admin
  devise_for :admin_users, controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: 'homes#top'
    resources :admin_users, only:[:index, :show, :edit, :update] do
      get :edit_pass, on: :member
    end
    resources :end_users, only:[:index, :show, :edit, :update]
    resources :areas, only:[:index, :create, :edit, :update]
    resources :jobs, only:[:index, :create, :edit, :update]
    resources :notifications, only: :index
    resources :trees, only:[:index, :new, :create, :show, :edit, :update, :destroy] do
      post :confirm, on: :collection
      resources :responses, only:[:create, :edit, :update, :destroy]
    end
    resource :searches, only:[] do
      collection do
        get 'search'
        get 'admin_user_search'
        get 'end_user_search'
      end
    end
  end


  # 拠点担当者　public
  devise_for :end_users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  scope module: :public do
    root to: 'homes#top'
    resources :end_users, only:[:index,:update] do
      collection do
        get 'mypage'
        get 'mypage_edit'
        get 'edit_pass'
      end
    end
    resources :notifications, only: :index
    resources :trees, only:[:index, :new, :create, :show, :edit, :update, :destroy] do
      post :confirm, on: :collection
      resources :responses, only:[:create, :edit, :update, :destroy]
    end
    get "search" => "searches"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
