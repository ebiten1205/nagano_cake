class Public::ItemsController < ApplicationController
  def index
    @item = Item.page(params[:page])
  end
  
  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    if customer_signed_in?
      @cart_items = CartItem.where(customer_id:[current_customer.id])
    end
  end
  
  private
  def item_params
  params.require(:items).permit(:name,:image,:introduction,:price)
  end
  
end
