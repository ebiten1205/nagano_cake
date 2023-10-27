class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

   def index
      if params[:customer_id]
         orders = Order.where(customer_id: params[:customer_id])
         @index_orders = orders.order(created_at: "DESC").page(params[:page])
      elsif params[:created_at]
         orders = Order.created_today
         @index_orders = orders.order(created_at: "DESC").page(params[:page])
      elsif params[:status] == "not"
         orders = Order.where.not(order_status: 0).where.not(order_status: 4)
         @index_orders = orders.order(created_at: "DESC").page(params[:page])
      else
         @index_orders = Order.order(created_at: "DESC").page(params[:page])
      end
   end

   def show
   	@order = Order.find(params[:id])
   	@order_details = OrderDetail.where(order_id:[@order.id])
   end

   def update
   	@order = Order.find(params[:id])
      @order_details = OrderDetail.where(order_id: [@order.id])
      @order.update(order_params)
      redirect_to admin_order_path(@order)
   end

   private
   def order_params
      params.require(:order).permit(:customer_id, :postcode, :address, :payment_method, :postage, :payment)
   end

end
