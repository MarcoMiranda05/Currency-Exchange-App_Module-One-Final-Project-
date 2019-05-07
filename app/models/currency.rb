class Currency < ActiveRecord::Base
  has_many :countries, through: :currencyusages
end
