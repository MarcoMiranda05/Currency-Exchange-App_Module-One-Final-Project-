class Trip < ActiveRecord::Base
  belongs_to :user
  # belongs_to :country
  belongs_to :home_country, :class_name => :Country,:foreign_key => "home_country_id"
  belongs_to :destination_country, :class_name => :Country,:foreign_key => "destination_country_id"
  belongs_to :hotel
end
