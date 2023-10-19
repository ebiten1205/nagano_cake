Rails.application.routes.draw do
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  # moduleはURLに、今回でいうとpublicをつけないようにできる。
  scope module: :public do
    get '/about' => 'homes#about', as: 'about'
    #resources :の後にはテーブル名を記載。そのあとにonlyオプションでアクション名を記述。
    #注意　resourcesを使った場合にうまくアクションを認識できない場合がある。今回だとordersコントローラーが
    # 例でresourceにordersコントローラーを入れてしまうとなぜかshowアクションとしてconfirmationアクション認識されてしまうため、
    # そういった場合にはresourceから外して1つずつurlを設定していくしかない。下記のordersのurlのように。
    resources :items, :customers, :cart_items, only: [:index, :show, :create, :destroy, :new]
     root to: "homes#top"
     # URLを自分で決めたものにカスタムするには、HTTPメソッド "任意のURL"=>"コントローラー名＃アクション名"　の形式の記述で変更できる。
     get "/customers/edit"=>"customers#edit"
     get "/customers/my_page"=>"customers#show"
     get "/customers/unsubscribe"=>"customers#unsubscribe"
     get "/orders/new"=>"orders#new"
     get "/orders/confirmation"=>"orders#confirmation"
     post "/orders/confirmation"=>"orders#confirmation"
     get "/orders/completed"=>"orders#completed"
     post "/orders"=>"orders#create"
     get "/orders"=>"orders#index"
     get "/orders/:id"=>"orders#show", as: "customer_order"
     patch "/customers/withdrawal"=>"customers#withdrawal"
     delete "/cart_items/destroy_all"=>"cart_items#destroy_all", as: "destroy_all_cart_items"
  end
  
  # namespaceはURLに、今回でいうとadminをつけるようにできる。
  # namespaceなどの使い方に関しての資料はブックマークに保存してある。
  namespace :admin do
    resources :sessions, :items, :customers, :orders, only: [:new, :index, :show, :edit, :create, :update]
    root to: 'homes#top'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
