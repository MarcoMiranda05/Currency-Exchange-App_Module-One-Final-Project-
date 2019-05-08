require 'pry'
require 'rest-client'
require 'json'
require 'tty-prompt'
require 'tty-table'
require 'require_all'

# where are you travelling from
# where are you travelling to
# how many nights are you staying
# how many stars will you hotel have

# total_local_currency = (hotel_price + (meal_price * 3)) * nights
# required_home_currency = total_local_currency / exchange_rate

# you should exchange #{required_home_currency}
#

def greeting(name)
  puts "Hello #{name}!

  Welcome to our Amazing Currency Exchange!

  "
end

def menu
  prompt = TTY::Prompt.new
  options =
    ["Convert your money",
    "Check your currency rate compared to a specific currency",
    "Check your currency rate compared all the others currencies",
    "Find the currency by country",
    "Find country by currency",
    "Check all the countries covered by us",
    "Check all the currencies covered by us", "Exit"]

  selection = prompt.select("Choose one option

    ", options, cycle: true)

    case selection

    when "Convert your money"
      convertor_app
    when "Check your currency rate compared to a specific currency"
      checking_specific_currency
    when "Check your currency rate compared all the others currencies"
      checking_all_currencies
    when "Find the currency by country"
      find_by_country
    when "Find country by currency"
      find_by_currency
    when "Check all the countries covered by us"
      all_countries
    when "Check all the currencies covered by us"
      all_currencies
    when "Exit"
      puts "Thanks! See you next time."
      exit
    end



end

def all_countries
  puts Country.all.map {|country| country.name}.sort
  quit_or_menu
end

def all_currencies
  puts Currency.all.map { |currency|
    "#{currency.name} ==> #{currency.symbol}"
  }.sort
  quit_or_menu
end


def find_by_country
  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("Which country are you looking for?", countries, filter: true)

  puts Currencyusage.all.find{|currencyusage| currencyusage.country.name == "#{user_selection}"}.currency.name
  quit_or_menu
end

def find_currency_symbol_by_country(country)
  Currencyusage.all.find{|currencyusage| currencyusage.country.name == country}.currency.symbol
end

def find_by_currency
  prompt = TTY::Prompt.new
  currencies = Currency.all.map {|currency| currency.name}.sort
  user_selection = prompt.select("Which currency are you looking for?", currencies, filter: true)

  puts Currencyusage.all.select{ |currencyusage| currencyusage.currency.name == "#{user_selection}"}.map {|currencyusage| currencyusage.country.name}
  quit_or_menu
end

def checking_all_currencies
  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("Which country currency do you want to check?", countries, filter: true)

  country_name = find_currency_symbol_by_country("#{user_selection}")
  your_currency = country_name
  base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
  result = JSON.parse(base)

   rates_only = result["rates"]
   table_rows = []
   rates_only.each do |symbol, rate|
     table_rows << [symbol, rate.round(2)]
   end
   table = TTY::Table.new ["Currency", "Rate"], table_rows
   renderer = TTY::Table::Renderer::ASCII.new(table)
   puts renderer.render
   quit_or_menu
end

def checking_specific_currency
  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("Which is your home country?", countries, filter: true)
    country_name = find_currency_symbol_by_country("#{user_selection}")
    your_currency = country_name

  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("Your currency is #{your_currency}. Which currency do you want to compare with?", countries, filter: true)

    target_country_name = find_currency_symbol_by_country("#{user_selection}")
    target_currency = target_country_name
    base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
    result = JSON.parse(base)
    final_result = result["rates"]["#{target_currency}"]
  puts "Every #{your_currency} is equal to #{final_result.round(2)} #{target_currency}"
  quit_or_menu
end

def convertor_app
  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("Which is your home country?", countries, filter: true)

  country_name = find_currency_symbol_by_country("#{user_selection}")
  your_currency = country_name

  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("Your currency is #{your_currency}. Which currency do you want to convert to?", countries, filter: true)

  target_country_name = find_currency_symbol_by_country("#{user_selection}")
  target_currency = target_country_name
  base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
  result = JSON.parse(base)
  final_result = result["rates"]["#{target_currency}"]
  puts "

  How much do you want to convert?

  "
  value = gets.chomp
  total = final_result.to_f * value.to_f
  puts "Great!
  #{value} #{your_currency} is equal to #{total.round(2)} #{target_currency}!

  "

  quit_or_menu
end


def quit_or_menu
  prompt = TTY::Prompt.new
  answer = prompt.select( "

    Would you like to go back to the main menu or exit?

    ",
    ["Main menu",
     "Exit"
    ])
  case answer

  when "Main menu"
    menu
  when "Exit"
    puts "

    Thanks! See you next time.

    "
    exit
  end
end
