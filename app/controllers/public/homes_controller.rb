class Public::HomesController < ApplicationController
  def top
    @recomend_items = Item.all.last(4)
  end
  
  def about
  end
end
