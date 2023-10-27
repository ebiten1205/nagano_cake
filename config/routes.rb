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
    # 注意　resourcesで作ったルートに関してはurlに必ず/:idと入ってしまい、エラーの原因になりやすいため注意が必要。
    resources :items, only: [:index, :show, :create, :new, :edit, :update]
     root to: "homes#top"
     # URLを自分で決めたものにカスタムするには、HTTPメソッド "任意のURL"=>"コントローラー名＃アクション名"　の形式の記述で変更できる。
     # またルーティングを各順番にも気を付ける（上から順番に読まれる）。
     get "/customers/my_page/edit"=>"customers#edit"
     patch "/customers/my_page"=>"customers#update"
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
     get "/cart_items" => "cart_items#index", as: "cart_items"
     post "/cart_items" => "cart_items#create"
     patch "/cart_items/:id" => "cart_items#update",as: "cart_item"
     delete "/cart_items/destroy_all"=>"cart_items#destroy_all", as: "destroy_all_cart_items"
     delete "/cart_items/:id" => "cart_items#destroy", as: "destroy_cart_items"
  end
  
  # namespaceはURLに、今回でいうとadminをつけるようにできる。
  # namespaceなどの使い方に関しての資料はブックマークに保存してある。
  namespace :admin do
    resources :sessions, :items, :customers, only: [:new, :index, :show, :edit, :create, :update]
    root to: 'homes#top'
    get "orders" => "orders#index", as: "orders"
    get "orders/:id" => "orders#show", as: "order_detail"
    patch "orders/:id" => "orders#update"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
