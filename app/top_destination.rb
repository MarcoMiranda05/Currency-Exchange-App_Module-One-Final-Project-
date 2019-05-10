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


# def top_destinations
#   Trip.all.map {|trip| trip.destination_country
#   }.group_by{|country| country.name}.map{|country, trips|[country, trips.count]
#   }.sort_by{|country| country[1]}.reverse.map{|country| "#{country[1]} - #{country[0]}"
# }.each{|string| puts string}
# end
