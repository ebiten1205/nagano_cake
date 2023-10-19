class Public::OrdersController < ApplicationController
  
  before_action :order_is_valid,only:[:new, :confirmation, :create]
  before_action :authenticate_customer!
  
  def new
    @order = Order.new
    @cart_items = CartItem.where(customer_id:[current_customer.id])
    @registered_addresses = RegisteredAddress.all
  end
  
  def confirmation
    
    @cart_items = CartItem.where(customer_id:[current_customer.id])
    @order = Order.new(order_params)
    @total = 0
    @postage = 800
    @selected_payment_method = params[:order][:payment_method]
    @order.postal_code = current_customer.postal_code
    @order.address = current_customer.address
    @order.name = current_customer.first_name + current_customer.last_name
    @payment_method = params[:order][:payment_method]
    @delivery_address = params[:order][:delivery_address]
    case @delivery_address
      when "customer_address"
        @address = current_customer.postal_code + " " + current_customer.address + " " + current_customer.last_name + current_customer.first_name
      when "registered_address"
        unless params[:order][:registered_address_id] == ""
          selected = Address.find(params[:order][:registered_address_id])
          @selected_address = selected.postal_code + " " + selected.address + " " + selected.name
          @registered_address = params[:order][:registered_address_id]
	else	 
	   render :new
	end
      when "new_address"
        unless params[:order][:new_postal_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
        @postal_code = params[:order][:postal_code]
        @address = params[:order][:address]
        @name = params[:order][:name]
	  @selected_address = params[:order][:postal_code] + " " + params[:order][:address] + " " + params[:order][:name]
	else
	  render :new
	end
    end
  end
  
  def create
    
      @order = Order.new
      @order.customer_id = current_customer.id
      @order.postage = 800
      @cart_items = CartItem.where(customer_id: current_customer.id)
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.price*cart_item.amount
      end
      @cart_items_price = ary.sum
      @order.total_payment = @order.postage + @cart_items_price
      @order.payment_method = params[:order][:payment_method]
      
      delivery_address = params[:order][:delivery_address]
      case delivery_address
      when "customer_address"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
      when "registered_address"
      Addresse.find(params[:order][:registered_address_id])
      selected = Addresse.find(params[:order][:registered_address_id])
      @order.postal_code = selected.postal_code
      @order.address = selected.address
      @order.name = selected.name
      when "new_address"
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
      end
      
      # ↓saveの後に!をつけて、起動させることでデータがちゃんと保存されるかを確認できる
      if @order.save!
            @cart_items.each do |cart_item|
               OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount)
            end
            @cart_items.destroy_all
            redirect_to completed_orders_path
      else
            flash[:notice] = "項目に不備があります"
            redirect_to orders_new_path
      end
  end

  
   def completed
   end
   
   def index
     @orders = Order.where(customer_id:[current_customer.id])
   end
   
   def show
     @order = Order.find(params[:id])
     if @order.customer_id != current_customer.id
       redirect_to root_path
     end
     @order_details = OrderDetail.where(order_id: @order.id)
   end
         
  
  
  private
  
  def order_params
    params.require(:order).permit(:payment_method, :postal_code, :address, :name, :customer_id, :postage, :amount)
  end
  
  def order_is_valid
    @cart_items = CartItem.where(customer_id:[current_customer.id])
    if @cart_items.present? == false
      redirect_to root_path
    end
  end
  
end
