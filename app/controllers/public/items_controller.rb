class Public::ItemsController < ApplicationController
  def index
    @item = Item.page(params[:page])
  end
  
  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem
  end
  
  private
  def item_params
  params.require(:items).permit(:name,:image,:introduction,:price)
  end
  
end
