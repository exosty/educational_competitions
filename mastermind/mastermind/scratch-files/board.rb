require_relative '../lib/board.rb'

b = Mastermind::Board.new(4, 8)
puts b.num_rows
puts b.num_columns
