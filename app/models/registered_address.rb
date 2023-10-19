class RegisteredAddress < ApplicationRecord
  def registered_address_display
    '〒' + postal_code + ' ' + address + ' ' + name
  end
end
