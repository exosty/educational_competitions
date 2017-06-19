require_relative '../lib/mastermind.rb'

puts "type in anything to customize settings"
puts "to use default settings, leave blank & press enter"

choice = gets.chomp
choice = choice == '' ? nil : :true

settings = Mastermind::Game.get_settings(choice)
puts settings
