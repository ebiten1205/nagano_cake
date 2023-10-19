class Item < ApplicationRecord
  has_one_attached :image
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  
  validates :price, presence: true, numericality: true
  validates :introduction, presence: true, length: {maxinum: 140, minimum: 10}
  validates :name, presence: true, uniqueness: true
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  
  def taxin_price
        price*1.1
  end
  
  def with_tax_price
      (price * 1.1).floor
  end
  
end
