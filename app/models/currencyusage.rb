class Currencyusage < ActiveRecord::Base
  belongs_to :country
  belongs_to :currency
end
