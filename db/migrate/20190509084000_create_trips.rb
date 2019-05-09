class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.integer :user_id
      t.integer :home_country_id
      t.integer :destination_country_id
      t.integer :hotel_id
      t.integer :amount_of_nights
      t.float :total_destination_currency
      t.float :total_home_currency
      t.date :rated_when?, :default => Time.now
      t.timestamps
    end
  end
end
