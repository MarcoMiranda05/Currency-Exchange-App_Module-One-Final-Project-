require_relative '../config/environment'



#
# latest_res = RestClient.get("https://api.exchangeratesapi.io/latest")
# historical_res = RestClient.get("https://api.exchangeratesapi.io/2010-01-12")
#
# LATEST = JSON.parse(latest_res)
# HISTORICAL = JSON.parse(historical_res)

# puts LATEST["rates"].flatten

greeting

menu

checking_all_currencies

puts "You did it!"











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
