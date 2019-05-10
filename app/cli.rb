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

def main_menu
  system "clear"
  prompt = TTY::Prompt.new
  options = ["Create an Account", "Plan a trip", "Conversion Calculator", "Check coverage","Exit"]
  selection = prompt.select("
  Main Menu".colorize(:color => :green, :background => :black), options, cycle: true)

  case selection

  when options[0]
    create_a_user

  when options[1]
    plan_trip_menu

  when options[2]
    conversion_menu

  when options[3]
    check_coverage_menu

  when options[4]
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

def plan_trip_menu
  prompt = TTY::Prompt.new
  options = ["Create a trip", "My Trips","Top destination",  "Top destination by country COMING SOON!", "Exit"]
  selection = prompt.select("
  What would you like to do?".colorize(:color => :green, :background => :black), options, cycle: true, filter: true)


  case selection

  when options[0]
    create_a_trip

  when options[1]
    my_trips
  when options[2]
    top_destinations
  when options[3]
    feature_coming_soon
  when options[4]
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


def conversion_menu
  prompt = TTY::Prompt.new
  options =
    ["Convert your money",
    "Check your currency rate compared to a specific currency",
    "Check your currency rate compared all the others currencies",
    "Find the currency by country",
    "Find country by currency",
     "Exit"]

  selection = prompt.select("
  What would you like to do?".colorize(:color => :green, :background => :black), options, cycle: true)

    case selection

    when options[0]
      system "clear"
      convertor_app
    when options[1]
      system "clear"
      checking_specific_currency
    when options[2]
      system "clear"
      checking_all_currencies
    when options[3]
      system "clear"
      find_by_country
    when options[4]
      system "clear"
      find_by_currency

    when options[5]
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

def check_coverage_menu

  prompt = TTY::Prompt.new
  options =
    ["Check all the countries covered by us",
      "Check all the currencies covered by us",
     "Exit"]

  selection = prompt.select("
  What would you like to do?".colorize(:color => :green, :background => :black), options, cycle: true)


  case selection
  when options[0]
    system "clear"
    all_countries
  when options[1]
    system "clear"
    all_currencies
  when options[2]
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
  options = ["Convert money", "Plan a trip", "Check Coverage", "Exit"]
  answer = prompt.select( "
  What would you like to do?".colorize(:color => :green, :background => :black),
    options)
  case answer

  when options[0]
    system "clear"
    conversion_menu
  when options[1]
    system "clear"
    plan_trip_menu
  when options[2]
    system "clear"
    check_coverage_menu
  when options[3]
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


def feature_coming_soon
  puts  "You'll be able to checkout the top vacation spots for people from your country"
end

def top_destinations
  Trip.all.map {|trip| trip.destination_country
  }.group_by{|country| country.name}.map{|country, trips|[country, trips.count]
  }.sort_by{|country| country[1]}.reverse.map{|country| "#{country[1]} - #{country[0]}"
}.each{|string| puts string}
end

def create_a_user
  puts "
  Let's setup your account!
  What is your full name?"

  name = gets.chomp

  puts "
  Now lets define your username:"

  username = gets.chomp

  puts "Great, #{name}! Now you're ready to plan and check your planned trips!"

  User.create(name: name, username: username)

  quit_or_menu
end



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
