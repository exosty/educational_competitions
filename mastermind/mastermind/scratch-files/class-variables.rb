require_relative '../lib/mastermind.rb'

game = Mastermind::Game.new(Mastermind::Game.get_settings)
gb = game.guess_board
hb = game.hint_board

puts Mastermind::Game.current_turn
4.times do
  Mastermind::Game.inc_turn
  puts Mastermind::Game.current_turn
  puts gb.class.superclass.current_turn
  puts
end

