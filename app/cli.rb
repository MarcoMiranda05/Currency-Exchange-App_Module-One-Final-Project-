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
  prompt.select("Choose one option", ["Check all the countries covered by us",
     "Check all the currencies covered by us",
    "Find the currency by country",
    "Find country by currency",
    "Check your currency rate compared all the others currencies",
    "Check your currency rate compared to a specific currency",
    "Convert your money"], cycle: true)
end

def all_countries
  Country.all.map {|country| country.name}
end

def all_currencies
  Currency.all.map { |currency|

    "#{currency.name} ==> #{currency.symbol}"
  }
end

def find_by_country
  puts "Which country are you looking for?"
  answer = gets.chomp
  Currencyusage.all.find{|currencyusage| currencyusage.country.name = answer}.currency.name
end

def find_by_currency
  puts "Which currency are you looking for?"
  answer = gets.chomp
  Currencyusage.all.select{ |currencyusage| currencyusage.currency.name = answer}.map {|currencyusage| currencyusage.country.name}
end

def checking_all_currencies
  puts "Which currency do you want to check?"

   your_currency = gets.chomp

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
end


def checking_specific_currency
  puts "Which currency do you want to check?"

   your_currency = gets.chomp

   base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")

   base.select

   result = JSON.parse(base)

   puts "country found"
end
  # puts table_rows

# def welcome
#   puts "Welcome to Our Amazing Currency Exchange"
#   puts "What would you like to do?"
# end

# prompt.select("Choose one option", %w(counties currencies))


# puts "1 --> (Check all the countries covered by us)"
# puts "2 --> (Check all the currencies covered by us)"
# puts "3 --> (Find the currency by country)"
# puts "4 --> (Find country by currency)"
# puts "5 --> (Check your currency rate compared all the others currencies)"
# puts "6 --> (Check your currency rate compared to a specific currency)"
# puts "7 --> (Convert your money)"
#
# puts "Please, choose your option by typing the number"
# user_answer = gets.chomp
#


# def menu_selection
#   user_answer = " "
#   while user_answer
#     user_anser = gets.chomp
#     case user_anser
#     when "5"
#         checking_all_currencies(your_currency)
#         puts rates_only
#       end
#     end
#   end


    # != "exit"
    # puts "Please enter a valid command"
    # user_anser = gets.chomp
    # if user_answer == 05
    #   puts "Great!"
    #   checking_all_currencies(your_currency)
    # else
    #   exit
#     end
#   end
# end









# rates_only = TTY::Table.new ['Currency', 'Rates'] [['a1', 'a2'], ['b1','b2']]
#
# puts rates_only.render
