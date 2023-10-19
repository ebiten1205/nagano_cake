class Public::CustomersController < ApplicationController
  
  # 今回の場合はIDでデータを分けていないため、ログインしているcustomerという形で
  # 定義してあげるといい。ログインしているcustomer＝current_customer
  def show
    @customer = current_customer
  end
  
  def withdrawal
    @customer = Customer.find(current_customer.id)
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end
  
  
  
  def edit
    @customer = current_customer
  end
end
