require_relative '../lib/mastermind.rb'

game = Mastermind::Game.new(Mastermind::Game.get_settings())

game.guess_board.rows[0] = ([:red, :blue, :green, :yellow])
game.guess_board.rows[1] = ([:yellow, :green, :blue, :red])
game.guess_board.rows[2] = ([:green, :yellow, :blue, :red])
game.guess_board.rows[3] = ([:green, :yellow, :red, :blue])

game.hint_board.rows[0] = ([:white, :white, nil, nil])
game.hint_board.rows[1] = ([:black, :black, :black, nil])
game.hint_board.rows[2] = ([:black, :white, nil, nil])
game.hint_board.rows[3] = ([nil, nil, nil, nil])

puts game

options = { 
  guess_board: game.guess_board,
  hint_board: game.hint_board
}

merged = Printer.merge_two_boards(options)
Printer.print_board(merged)
puts
puts game.answer_board.rows
Printer.print_board(game.answer_board)
