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


def create_a_trip

    puts "
  Insert you username:".colorize(:color => :green, :background => :black)
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

    prompt = TTY::Prompt.new
    countries = Country.all.map {|country| country.name}.sort
    home_country = prompt.select("
  Where are you travelling from?".colorize(:color => :green, :background => :black), countries, filter: true)
    home_country_id = Country.all.find {|country| country.name == "#{home_country}"}.id
      home_currency = find_currency_symbol_by_country("#{home_country}")
      base_currency = home_currency

    prompt = TTY::Prompt.new
    countries = Country.all.map {|country| country.name}.sort
    destination_country = prompt.select("
  Where are you travelling to?".colorize(:color => :green, :background => :black), countries, filter: true)
    destination_country_id = Country.all.find {|country| country.name == "#{destination_country}"}.id


      destination_currency = find_currency_symbol_by_country("#{destination_country}")
      destination_currency_symbol = destination_currency
      base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{base_currency}")
      result = JSON.parse(base)
      convertion_rate = result["rates"]["#{destination_currency_symbol}"]

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
