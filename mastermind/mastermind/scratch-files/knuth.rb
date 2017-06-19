require_relative '../lib/mastermind'
require_relative '../lib/knuth'

game = Mastermind::Game.new(Mastermind::Game.get_settings())
dk = Knuth.new('dk', 4, Mastermind::CodePeg.available_colors)

define_method :one_turn do
  guess1 = game.breaker.make_guess('yellow magenta black white')
  game.guess_board.receive(guess1)
  hint = game.maker.give_hint(guess1)
  game.hint_board.receive(hint)
end

define_method :print_stuff do
  puts
  puts "merged guess & answer board"
  two_boards = {guess_board: game.guess_board, hint_board: game.hint_board}
  Printer.print_board(Printer.merge_two_boards(two_boards))
end

# given 4 pegs & 6 colors, there are 6**4 (1296) different patterns
#   assuming you are allowing duplicates

# 1. create set of 1296 possible codes
#   1111, 1112, 1113..6666
#   call that set, S

def get_set(key_size, unique_values)
  unique_values.repeated_permutation(key_size).to_a
end

# 2. start with initial guess 1122
# 3. play the guess to get response of colored & white pegs
# 4. if response is 4 colored pegs, then game is won 
# 5. otherwise, remove any code from S that would NOT give same response if the guess were the code

# 6. apply minimax technique to find the next guess
#   a) for each possible guess of original set of 1296: calculate how many possibilities it might eliminate from S

def min(a,b)
  a >= b ? a : b
end

def max(a,b)
  a <= b ? a : b
end

# block can be:
#   `min` for getting minimum value
#   `max` for getting maximum value
def inject_total(unique_values, &block)
  unique_values.inject(0) do |total, num|
    n_in_code = count_hits(num, secret_code)
    n_in_guess = count_hits(num, guess)
    total += block.call(n_in_code, n_in_guess)
  end
end
# 7. repeat from step 3
