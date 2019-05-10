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



def quit_or_menu
  prompt = TTY::Prompt.new
  options = [ "Convert money", "Plan a trip", "Check Coverage", "Exit"]
  answer = prompt.select( "
  What would you like to do?".colorize(:color => :green, :background => :black),
    options, cycle: true)
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
