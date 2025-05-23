class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  
    add_index :addresses, :zip_code
  end
end
