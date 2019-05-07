class Country < ActiveRecord::Base
  has_one :currency, through: :currencyusages
  has_many :currencyusages
end
