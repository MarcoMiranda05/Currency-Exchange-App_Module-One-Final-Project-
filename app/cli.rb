require 'pry'
require 'rest-client'
require 'json'


def checking_all_currencies(your_currency)
  puts "What's your home currency?"

  your_currency = gets.chomp

  base = RestClient.get("https://api.exchangeratesapi.io/latest?base=#{your_currency}")

  result = JSON.parse(base)

  puts "country found"

  rates_only = result["rates"]

  puts rates_only
end

puts "Welcome to Our Amazing Currency Exchange"
puts "What would you like to do?"

# prompt.select("Choose one option", %w(counties currencies))


puts "1 --> (Check all the countries covered by us)"
puts "2 --> (Check all the currencies covered by us)"
puts "3 --> (Find the currency by country)"
puts "4 --> (Find country by currency)"
puts "5 --> (Check your currency rate compared all the others currencies)"
puts "6 --> (Check your currency rate compared to a specific currency)"
puts "7 --> (Convert your money)"

puts "Please, choose your option by typing the number"
user_answer = gets.chomp



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
