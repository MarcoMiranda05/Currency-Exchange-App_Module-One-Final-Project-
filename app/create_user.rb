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


def create_a_user
  puts "
  Let's setup your account!" + "

  What is your full name?".colorize(:color => :green, :background => :black)

  name = gets.chomp

  puts "
  Now lets define your username:".colorize(:color => :green, :background => :black)

  username = gets.chomp

  puts "
  Great, #{name}! Now you're ready to plan and check your trips!"

  User.create(name: name, username: username)

  quit_or_menu
end
