require 'pry'
require 'rest-client'
require 'json'
require 'tty-prompt'
require 'tty-table'
require 'colorize'
require 'tty-font'
require 'pastel'
require 'require_all'

# where are you travelling from
# where are you travelling to
# how many nights are you staying
# how many stars will you hotel have

# total_local_currency = (hotel_price + (meal_price * 3)) * nights
# required_home_currency = total_local_currency / exchange_rate

# you should exchange #{required_home_currency}
#


def greeting
  font = TTY::Font.new(:doom)
  pastel = Pastel.new
  puts pastel.black.bold(font.write("MyExchange"))
  puts "


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

  selection = prompt.select("
  What would you like to do?".colorize(:color => :green, :background => :black), options, cycle: true)

    case selection

    when "Convert your money"
      system "clear"
      convertor_app
    when "Check your currency rate compared to a specific currency"
      system "clear"
      checking_specific_currency
    when "Check your currency rate compared all the others currencies"
      system "clear"
      checking_all_currencies
    when "Find the currency by country"
      system "clear"
      find_by_country
    when "Find country by currency"
      system "clear"
      find_by_currency
    when "Check all the countries covered by us"
      system "clear"
      all_countries
    when "Check all the currencies covered by us"
      system "clear"
      all_currencies
    when "Exit"
      pastel = Pastel.new
      puts pastel.black.bold("
    Thanks! See you next time.
      " )
      puts  "
    [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅] [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅] [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅]
      ".colorize(:green)
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
  user_selection = prompt.select("
  Which country are you looking for?".colorize(:color => :green, :background => :black), countries, filter: true)

  puts Currencyusage.all.find{|currencyusage| currencyusage.country.name == "#{user_selection}"}.currency.name
  quit_or_menu
end

def find_currency_symbol_by_country(country)
  Currencyusage.all.find{|currencyusage| currencyusage.country.name == country}.currency.symbol
end

def find_by_currency
  prompt = TTY::Prompt.new
  currencies = Currency.all.map {|currency| currency.name}.sort
  user_selection = prompt.select("
  Which currency are you looking for?".colorize(:color => :green, :background => :black), currencies, filter: true)

  puts Currencyusage.all.select{ |currencyusage| currencyusage.currency.name == "#{user_selection}"}.map {|currencyusage| currencyusage.country.name}
  quit_or_menu
end

def checking_all_currencies
  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("
  Which country currency do you want to check?".colorize(:color => :green, :background => :black), countries, filter: true)

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
  user_selection = prompt.select("
  Which is your home country?".colorize(:color => :green, :background => :black), countries, filter: true)
    country_name = find_currency_symbol_by_country("#{user_selection}")
    your_currency = country_name

  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("
  Your currency is #{your_currency}. Which currency do you want to compare with?".colorize(:color => :green, :background => :black), countries, filter: true)

    target_country_name = find_currency_symbol_by_country("#{user_selection}")
    target_currency = target_country_name
    base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
    result = JSON.parse(base)
    final_result = result["rates"]["#{target_currency}"]
  puts "
  Every" + " #{your_currency}".colorize(:green) + " is equal to" + " #{final_result.round(2)} #{target_currency}".colorize(:green)
  quit_or_menu
end

def convertor_app
  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("
  Which is your home country?".colorize(:color => :green, :background => :black), countries, filter: true)

  country_name = find_currency_symbol_by_country("#{user_selection}")
  your_currency = country_name

  prompt = TTY::Prompt.new
  countries = Country.all.map {|country| country.name}.sort
  user_selection = prompt.select("
  Your currency is #{your_currency}. Which currency do you want to convert to?".colorize(:color => :green, :background => :black), countries, filter: true)

  target_country_name = find_currency_symbol_by_country("#{user_selection}")
  target_currency = target_country_name
  base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")
  result = JSON.parse(base)
  final_result = result["rates"]["#{target_currency}"]
  puts "
  How much do you want to convert?".colorize(:color => :green, :background => :black)
  value = gets.chomp
  total = final_result.to_f * value.to_f
  puts "
  Great!" + "
  #{value} #{your_currency}".colorize(:green) + " is equal to" + " #{total.round(2)} #{target_currency}".colorize(:green)

  quit_or_menu
end


def quit_or_menu
  prompt = TTY::Prompt.new
  answer = prompt.select( "
  Would you like to go back to the main menu or exit?".colorize(:color => :green, :background => :black),
    ["Main menu",
     "Exit"
    ])
  case answer

  when "Main menu"
    system "clear"
    menu
  when "Exit"
    system "clear"
    pastel = Pastel.new
    puts pastel.black.bold("
    Thanks! See you next time.
    " )
    puts  "
    [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅] [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅] [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅]
    ".colorize(:green)
    exit
  end
end
