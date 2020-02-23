Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "admin/base#admin_login"
  get 'welcome/index'

  post '/wx_payment', to: 'weixin#wx_verify'

  namespace :admin do
    #root "wx_menus#index"
    root "base#admin_login"
    get 'home' => 'base#home'
    get 'index' => 'admin#index' 
    post 'do_login' => 'admin#do_login'
    delete 'do_logout' => 'admin#do_logout' 

    resources :admin

    resources :ad_images do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :products do
      resources :product_images do
        collection do
          post :file_upload
          put :file_upload
          patch :file_upload
          put :up_serial
          put :down_serial
        end
        member do
          put :disable
          put :enable
        end
      end

      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
        put :up_serial
        put :down_serial
      end
      member do
        put :disable
        put :enable
      end
    end

    resources :stores

    resources :tags do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
        put :up_serial
        put :down_serial
      end
      member do
        put :disable
        put :enable
      end
    end

    resources :users
  end

  resources :applets, only: [:index, :show] do
    collection do
      get  :cart
      get  :cart_show
      post :check_order_status
      post :cancel_order
      post :create_order
      get  :crm_info
      post :delete_user_address
      get  :home_show
      get  :login
      get  :load_address_list
      get  :load_address_info
      get  :load_customer_info
      get  :product_show
      get  :set_phone
      post :save_address
      post :save_user_info
      get  :user_info
    end
  end
end
