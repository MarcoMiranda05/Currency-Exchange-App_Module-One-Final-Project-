require 'pry'
require 'rest-client'
require 'json'
require 'tty-prompt'
require 'tty-table'
require 'colorize'
require 'tty-font'
require 'pastel'
require 'require_all'
require_relative './cli'
require_relative '../config/environment'

def my_trips
  puts "Insert you username:"
  username = gets.chomp
  user_name = User.all.find {|user| user.username == "#{username}"}.name
  user_id = User.all.find {|user| user.username == "#{username}"}.id
  puts "Welcome, #{user_name}!"

  all_my_trips = Trip.all.select {|trip| trip.user_id == user_id}

  table = TTY::Table.new ["Home", "Destination", "Hotel", "Nights", "Foreign Currency", "Home Currency", "Rated When?"], []
  all_my_trips.select{|trip| trip.home_country && trip.destination_country && trip.hotel }
    .each do |trip|
      table << [
        trip.home_country.name,
        trip.destination_country.name,
        trip.hotel.name,
        trip.amount_of_nights,
        trip.total_destination_currency.round(2),
        trip.total_home_currency.round(2),
        trip.rated_when?.strftime("%b %d, %Y")
      ]
    end


  puts table.render(:unicode, width:150, resize:true)

  quit_or_menu
end

# def my_trips
#   puts "Insert you username:"
#   username = gets.chomp
#   user_name = User.all.find {|user| user.username == "#{username}"}.name
#   user_id = User.all.find {|user| user.username == "#{username}"}.id
#   puts "Welcome, #{user_name}!"
#
#   all_my_trips = Trip.all.select {|trip| trip.user_id == user_id}
#
#   table = TTY::Table.new ["Home", "Destination", "Hotel", "Nights", "Foreign Currency", "Home Currency", "Rated When?"], []
#   all_my_trips.select{|trip| trip.home_country && trip.destination_country && trip.hotel }.each do
#      |trip|
#       table << [
#         trip.home_country.name,
#         trip.destination_country.name,
#         trip.hotel.name,
#         trip.amount_of_nights,
#         trip.total_destination_currency.round(2),
#         trip.total_home_currency.round(2),
#         trip.rated_when?.strftime("%b %d, %Y")
#       ]
#     end
#   puts table.render(:unicode, width:150, resize:true)
# end
