class CreateRegisteredAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :registered_addresses do |t|

      t.timestamps
    end
  end
end
