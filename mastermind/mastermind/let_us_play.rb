require_relative './lib/mastermind.rb'

puts "Do you want to play a quick game with the default settings?"
puts "Or do you want to choose the settings? ie:"
puts "* Choose player names & roles?"
puts "* Choose to play against AI, another person or just watch 2 AI players"
puts "* Choose length of the secret code?"
puts "* Choose number of turns?"
puts
puts "To play a quick game, leave blank & press enter"
puts "To customize your settings, type in anything else & press enter"

choice = gets.chomp
choice = choice == '' ? nil : :true

settings = Mastermind::Game.get_settings(choice)
game = Mastermind::Game.new(settings)

game.play
