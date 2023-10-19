class CartItem < ApplicationRecord
  has_one_attached :image
  belongs_to :item
  belongs_to :customer
  
  validates :amount, presence: true
  
  
  def get_iamge
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  
  def sum_of_price
    item.taxin_price * amount
  end 
  
  def subtotal
      item.with_tax_price * amount
  end
end
