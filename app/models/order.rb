class Order < ApplicationRecord
  has_one_attached :image
  belongs_to :customer
  has_many :order_details, dependent: :destroy
  
  enum payment_method: { 銀行振込: 0, クレジットカード: 1 }
  
  validates :address, presence: true
  validates :payment_method, presence: true
  validates :postage, presence: true, numericality: true
  
end
