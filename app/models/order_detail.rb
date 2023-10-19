class OrderDetail < ApplicationRecord
  has_one_attached :image
  belongs_to :item
  belongs_to :order
  
  enum create_status: { 着手不可: 0,製作待ち: 1,製作中: 2,製作完了: 3}
end
