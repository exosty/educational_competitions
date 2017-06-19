require_relative 'printer'

module Mastermind
  class Board
    include Printer
    attr_accessor :current_turn
    attr_reader :num_columns, :num_rows, :rows

    def self.current_turn()
      Mastermind::Game.current_turn
    end

    @current_turn = self.current_turn

    def initialize(num_columns, num_rows)
      @num_columns = num_columns
      @num_rows = num_rows
      @rows = reset_rows(num_columns, num_rows)
    end

    # receives the guess as an array from the Codebreaker
    def receive(guess)
      type_err_msg = 'Please pass in an Array object'
      raise(TypeError, type_err_msg) if guess.class != Array
      place(guess)
    end

    private
    def reset_rows(num_columns, num_rows)
      rows = []
      num_rows.times { rows << Array.new(num_columns) }
      rows
    end
    
    def place(guess_or_hint)
      raise(TypeError) if guess_or_hint.class != Array
      # reference the class instance variable, @current_turn, like so:
      # self.class.current_turn
      index = self.class.current_turn || @rows.length - 1
      @rows[index] = guess_or_hint
      guess_or_hint
    end

    def old_place(guess_or_hint)
      raise(TypeError) if guess_or_hint.class != Array
      @rows.pop
      @rows.push(guess_or_hint)
      guess_or_hint
    end

  end

  class GuessBoard < Board
  end

  class HintBoard < Board
    # receives the response as a hash object from Codemaker
    # processes it into array and sends to private method #place
    def receive(response)
      type_err_msg = 'Please pass in a Hash object'
      raise(TypeError, type_err_msg) if response.class != Hash
      hint = []
      # any black pegs MUST be added before any white pegs are added
      response[:black].times { hint << :black }
      response[:white].times { hint << :white }
      (@num_columns - hint.length).times { hint << nil }
      place(hint)
    end
  end

  class AnswerBoard < Board
    def initialize(num_columns)
      @num_columns = num_columns
      @num_rows = 1
      @shielded = true
      @rows = reset_rows(num_columns, num_rows)
    end

    private
    def place(answer)
      raise(TypeError) if answer.class != Array
      @rows[0] = answer
      answer
    end
  end
end
