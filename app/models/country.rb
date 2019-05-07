class Country < ActiveRecord::Base
  has_one :currency, through: :currencyusages
end
