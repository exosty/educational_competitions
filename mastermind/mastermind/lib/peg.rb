module Mastermind
  # any Peg object is meant for one peg, not a set of them.
  class Peg

    attr_reader :color, :size, :available_colors

    def initialize(color)
      if self.class.is_color_correct?(color)
        @color = color
      else
        raise ArgumentError.new
      end
    end

    def self.available_colors; @available_colors; end

    def self.is_color_correct?(color)
      not @available_colors.find_index(color).nil?
    end

  end

  # a peg used by Codebreaker to place guesses
  # also, a peg used by Codemaker to reveal the secret pattern
  class CodePeg < Peg
    @available_colors = [:black, :red, :green, :yellow,
                      :blue, :magenta, :cyan, :white]
  end

  # a peg used by Codemaker to give hints for Codebreaker
  class HintPeg < Peg
    @available_colors = [:black, :white]
  end
end
