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

<<<<<<< HEAD:bin/test.rb
def top_destinations
  Trip.all.map {|trip| trip.destination_country
  }.group_by{|country| country.name}.map{|country, trips|[country, trips.count]
  }.sort_by{|country| country[1]}.reverse.map{|country| "#{country[1]} - #{country[0]}"
}.each{|string| puts string}
end


def create_a_user
  puts "Welcome to MyExchange!
  Let's setup your account!
  What is your full name?"

  name = gets.chomp

  puts "Nice to meet you, #{name}!
  Now define your username:"

  username = gets.chomp

  puts "Well done, #{name}! Now you're ready to plan and check your planned trips!"

  User.create(name: name, username: username)
end

def create_a_trip

    puts "Insert you username:"
    #create user method
=======

def create_a_trip

    puts "
  Insert you username:".colorize(:color => :green, :background => :black)
>>>>>>> 8cca0e2e2f9241a11c13bf668a863b34ecfcca76:app/create_trip.rb
    username = gets.chomp
    user_name = User.all.find {|user| user.username == "#{username}"}.name
    user_id = User.all.find {|user| user.username == "#{username}"}.id

    # if user_name
    # puts "
    # Welcome, #{user_name}!"
    # the_rest
    # else
    # puts "#{username} doesn't exist. Please try again"
    # create_a_trip
    # end

    #assign country method
    prompt = TTY::Prompt.new
    countries = Country.all.map {|country| country.name}.sort
    home_country = prompt.select("
  Where are you travelling from?".colorize(:color => :green, :background => :black), countries, filter: true)
    home_country_id = Country.all.find {|country| country.name == "#{home_country}"}.id
      home_currency = find_currency_symbol_by_country("#{home_country}")
      base_currency = home_currency

    #assign target country method (recycle country selection)
    prompt = TTY::Prompt.new
    countries = Country.all.map {|country| country.name}.sort
    destination_country = prompt.select("
  Where are you travelling to?".colorize(:color => :green, :background => :black), countries, filter: true)
    destination_country_id = Country.all.find {|country| country.name == "#{destination_country}"}.id

    #assign currency method
    destination_currency = find_currency_symbol_by_country("#{destination_country}")
    destination_currency_symbol = destination_currency
    base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{base_currency}")
    result = JSON.parse(base)
    convertion_rate = result["rates"]["#{destination_currency_symbol}"]

    #assign accomodation method
    prompt = TTY::Prompt.new
    hotels = Hotel.all.map {|hotel| hotel.name}
    accommodation_selection = prompt.select("
  Which kind of accommodation will you stay in?".colorize(:color => :green, :background => :black), hotels, filter: true)
    accommodation_price = Hotel.all.find {|accommodation| accommodation.name == "#{accommodation_selection}"}.price
    accommodation_id = Hotel.all.find {|accommodation| accommodation.name == "#{accommodation_selection}"}.id


    puts "
  How many nights you are planning to stay?".colorize(:color => :green, :background => :black)
    amount_of_nights = gets.chomp

    puts "
  Considering meals and others expenses (tickets, souviniers, etc), how much extra money you would like to take for your trip?".colorize(:color => :green, :background => :black)
    extra_money = gets.chomp

    total_home_currency = extra_money.to_f + (accommodation_price * amount_of_nights.to_i)
    total_destination_currency = total_home_currency.to_f * convertion_rate.to_f

    puts "
    Great #{user_name}! Your trip to #{destination_country} is now saved to 'My Trips.'
    You will need a total of" + " #{total_home_currency.round(2)} #{base_currency}".colorize(:color => :green) + ", which be equal to " + "#{total_destination_currency.round(2)} #{destination_currency_symbol}".colorize(:color => :green)

    Trip.create(user_id: user_id,
      home_country_id: home_country_id,
      destination_country_id: destination_country_id,
      hotel_id: accommodation_id,
      amount_of_nights: amount_of_nights.to_i,
      total_destination_currency: total_destination_currency.to_f,
      total_home_currency: total_home_currency.to_f
      )

      quit_or_menu
end
<<<<<<< HEAD:bin/test.rb

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
end

create_a_trip
my_trips
=======
>>>>>>> 8cca0e2e2f9241a11c13bf668a863b34ecfcca76:app/create_trip.rb
