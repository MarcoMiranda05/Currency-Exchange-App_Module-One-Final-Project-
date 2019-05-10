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
  puts "
  Insert you username:".colorize(:color => :green, :background => :black)

  username = gets.chomp
  user = User.all.find {|user| user.username == "#{username}"}


  if !user
    puts "
    #{username} doesn't exist."
    prompt = TTY::Prompt.new
    options = ["Try again", "Create an account", "Main Menu", "Exit"]
    answer = prompt.select( "
  What would you like to do?".colorize(:color => :green, :background => :black),
      options)
    case answer

    when options[0]
      my_trips
    when options[1]
      create_a_user
    when options[2]
      main_menu
    when options[3]
      exit
    end

    else
  puts "Welcome, #{user.name}!"

  all_my_trips = Trip.all.select {|trip| trip.user.id == user.id}

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
end

def top_destinations
  Trip.all.map {|trip| trip.destination_country  }
  .group_by do |country|
    # binding.pry
    country.name
  end.map{|country, trips|[country, trips.count]
  }.sort_by{|country| country[1]}.reverse.map{|country| "#{country[1]} - #{country[0]}"
}.each{|string| puts string}

  quit_or_menu
end
