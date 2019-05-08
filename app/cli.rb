require 'pry'
require 'rest-client'
require 'json'
require 'tty-prompt'
require 'tty-table'
require 'require_all'

def greeting
  puts "Welcome to our Amazing Currency Exchange!"
end

def menu
  prompt = TTY::Prompt.new
  selection = prompt.select("Choose one option", ["Convert your money",
     "Check your currency rate compared to a specific currency",
    "Check your currency rate compared all the others currencies",
    "Find the currency by country",
    "Find country by currency",
    "Check all the countries covered by us",
    "Check all the currencies covered by us", "Exit"])

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
  puts "Which country are you looking for?"
  answer = gets.chomp
  puts Currencyusage.all.find{|currencyusage| currencyusage.country.name == "#{answer}"}.currency.name
  quit_or_menu
end

def find_currency_symbol_by_country(country)
  Currencyusage.all.find{|currencyusage| currencyusage.country.name == country}.currency.symbol
end

def find_by_currency
  puts "Which currency are you looking for?"
  answer = gets.chomp
  puts Currencyusage.all.select{ |currencyusage| currencyusage.currency.name == "#{answer}"}.map {|currencyusage| currencyusage.country.name}
  quit_or_menu
end

def checking_all_currencies
  puts "Which country currency do you want to check?"
  country = gets.chomp
  country_name = find_currency_symbol_by_country("#{country}")
  your_currency = country_name
  base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
  result = JSON.parse(base)
   puts "country found"
   rates_only = result["rates"]
   table_rows = []
   rates_only.each do |symbol, rate|
     table_rows << [symbol, rate]
   end
   table = TTY::Table.new ["Currency", "Rate"], table_rows
   renderer = TTY::Table::Renderer::ASCII.new(table)
   puts renderer.render
   quit_or_menu
end

def checking_specific_currency
  puts "Which is your home country?"
    country = gets.chomp
    country_name = find_currency_symbol_by_country("#{country}")
    your_currency = country_name
  puts "You choose #{your_currency}. Which country currency do you want to compair with?"
    target_country = gets.chomp
    target_country_name = find_currency_symbol_by_country("#{target_country}")
    target_currency = target_country_name
    base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
    result = JSON.parse(base)
    final_result = result["rates"]["#{target_currency}"]
  puts "Every #{your_currency} is equal to #{final_result} #{target_currency}"
  quit_or_menu
end

def convertor_app
  puts "Which is your home country?"
  country = gets.chomp
  country_name = find_currency_symbol_by_country("#{country}")
  your_currency = country_name
  puts "You choose #{your_currency}. For which country currency do you want to convert?"
  target_country = gets.chomp
  target_country_name = find_currency_symbol_by_country("#{target_country}")
  target_currency = target_country_name
  base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
  result = JSON.parse(base)
  final_result = result["rates"]["#{target_currency}"]
  puts "How much do you want to convert?"
  value = gets.chomp
  total = final_result.to_f * value.to_f
  puts "Well done! #{your_currency} #{value} will value #{target_currency} #{total}!"

  quit_or_menu
end


def quit_or_menu
  prompt = TTY::Prompt.new
  answer = prompt.select( "Would you like to go back to the main menu or exit?",
    ["Main menu",
     "Exit"
    ])
  case answer

  when "Main menu"
    menu
  when "Exit"
    puts "Thanks! See you next time."
    exit
  end
end
