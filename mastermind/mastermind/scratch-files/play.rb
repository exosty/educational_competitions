require_relative '../lib/mastermind.rb'

game = Mastermind::Game.new(Mastermind::Game.get_settings())

# colors = [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white]
# rig the game so you know colors:
preset_colors = [ :yellow, :magenta, :black, :white ]
game.maker.send(:set_pattern, {pattern: preset_colors})

define_method :one_turn do
  # code breaker makes a move
  guess1 = game.breaker.make_guess('yellow magenta black white')
  # move is recorded on guess board (also updates guess_board internal array)
  game.guess_board.receive(guess1)
  # code maker evaluates the move & gives a hint
  hint = game.maker.give_hint(guess1)
  # hint sent to hint_board (also updates hint_board internal array)
  game.hint_board.receive(hint)
end

# print player names, board states
define_method :print_stuff do
  puts
  #puts game.breaker.name
  #puts game.maker.name
  #puts
  #puts "guess board"
  #Printer.print_board(game.guess_board)
  #puts "hint board"
  #Printer.print_board(game.hint_board)
  puts "all rows of guess_board:"
  game.guess_board.rows.each {|r| print r; puts}
  puts
  puts "all rows of hint_board:"
  game.hint_board.rows.each {|r| print r; puts}
  puts
  puts "all rows of the answer_board"
  game.answer_board.rows.each {|r| print r; puts}
  puts
  puts "the answer:"
  print game.maker.send(:show_pattern)
  puts
  puts "merged guess & answer board"
  two_boards = {guess_board: game.guess_board, hint_board: game.hint_board}
  Printer.print_board(Printer.merge_two_boards(two_boards))
  puts "answer board"
  Printer.print_board(game.answer_board)
end

one_turn()
print_stuff()
