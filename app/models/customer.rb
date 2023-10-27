class Customer < ApplicationRecord
  has_one_attached :image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
       
  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name_kana, presence: true
  validates :last_name_kana, presence: true
  validates :postal_code, presence: true, length: {maximum: 7, minimum: 7}, numericality: true
  validates :address, presence: true
  validates :telephone_number, presence: true, length: {maximum: 11, minimum: 10}, numericality: true
  
  def name
    last_name + first_name
  end

        
  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  def addresses
    postal_code + address + name
  end
  
end
