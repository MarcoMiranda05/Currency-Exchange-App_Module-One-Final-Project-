class CreateCurrencyusages < ActiveRecord::Migration[5.2]
  def change
    create_table :currencyusages do |t|
    t.integer :country_id
    t.integer :currency_id
    t.timestamps  
    end
  end
end
