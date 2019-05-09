class Hotel < ActiveRecord::Base
  has_many :trips
end

def accommodation_by_price
  Hotel.all.map {|accommodation| accommodation.price == self}
end
