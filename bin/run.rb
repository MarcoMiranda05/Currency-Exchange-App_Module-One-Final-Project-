require_relative '../config/environment'



#
# latest_res = RestClient.get("https://api.exchangeratesapi.io/latest")
# historical_res = RestClient.get("https://api.exchangeratesapi.io/2010-01-12")
#
# LATEST = JSON.parse(latest_res)
# HISTORICAL = JSON.parse(historical_res)

# puts LATEST["rates"].flatten

puts "

Hey there, what is your name?

"
name = gets.chomp
# User.find_or_create_by(name: name)
#
# $current_user = User.find_by(name: name)
#
# if $current_user
#   puts 'logged in successfully'
# else
#   $current_user = User.create(name: name)
#     puts 'new user created! logged in!'
# end
greeting(name)

menu

puts "You did it!"




#
# class Copy
#   def self.convet_your_money
#     if user.language == "en"
#     "Convert your money"
#     elsif user.languae == 'pt'
#       "obrigado"
#     end
#   end
# end
#




# result["rates"].each do |rate|
#
# end


#
# LATEST["rates"].each {|rate|
#
#   puts "Hi I'm #{rate}"
#   rate_res = RestClient.get(rate)
#      binding.pry
#   rate_hash = JSON.parse(rate_res)
#   puts rate_hash["type"]
#      }

#
# binding.pry
#
# puts "YASSSSSS"
