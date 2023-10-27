class Public::CartItemsController < ApplicationController
    def index
        @cart_items = CartItem.all
        # ↓合計金額の初期値を0にするための定義
        @total = 0 
    end
    
    def create
    @cart_item = CartItem.find_by(item_id: params[:cart_item][:item_id])
    if @cart_item
      #カートにitemが存在したらamountに新しいCart_itemのamountを足す
      @cart_item.amount += CartItem.new(cart_item_params).amount
    else
      #カートにitemが無ければ新しく作成する
      @cart_item = CartItem.new(cart_item_params)
    end
    #ログインcustomerのみ更新できるようにするため分岐の外に記述する
    @cart_item.customer_id = current_customer.id
    @cart_item.save!
    redirect_to cart_items_path
    end
    # プログラミング全体に言えることだが記述は上から順番に読まれるためそれを踏まえてコードを記述することが大事。
    def destroy_all
        current_customer.cart_items
        cart_items = current_customer.cart_items
        cart_items.destroy_all
        redirect_to cart_items_path, notice: 'カートが空になりました。' 
    end
    
    def destroy
        cart_item = CartItem.find(params[:id])
        cart_item.destroy
        redirect_to cart_items_path
    end
    
    def update
		cart_item = CartItem.find(params[:id])
		if cart_item.update(cart_item_params)
			redirect_to cart_items_path
		end
    end

 private
  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id, :customer_id, :price)
  end
end
