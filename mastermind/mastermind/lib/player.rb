module Mastermind

  class Player
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end

  class Codemaker < Player
    attr_reader :hint_colors

    def initialize(name, num_columns = 4, humanely_set_pattern = nil)
      @name = name
      @pattern = humanely_set_pattern.nil? ?
        set_pattern({code_length: num_columns}) :
        set_pattern({code_length: humanely_set_pattern.length, pattern: humanely_set_pattern})
        
      @hint_colors = [ HintPeg.available_colors[0], HintPeg.available_colors[1] ]
    end

    # receives array of symbols from Codebreaker#make_guess
    # returns hash
    def give_hint(guess)
      rate_guess(guess)
    end

    private
    def show_pattern()
      @pattern
    end

    def set_pattern(args = {})
      args[:pattern] ||= nil
      args[:code_length] ||= 4
      arr = args[:pattern].nil? ?
        Mastermind::CodePeg.available_colors.sample(args[:code_length]) :
        args[:pattern].map { |color| color }
      @pattern = arr
    end

    # excellent method by DonaldAli
    # https://github.com/donaldali/odin-ruby/blob/master/project_oop/mastermind/lib/mastermind/mastermind_module.rb
    def rate_guess(guess)
      response = { @hint_colors[0] =>  0, @hint_colors[1] => 0 }
      unmatched = { guesses: [], pattern: [] }
      pattern = show_pattern()

      place_black_pegs(guess, response, unmatched, pattern)
      place_white_pegs(guess, response, unmatched)

      response
    end

    define_method :place_black_pegs do |guess, response, unmatched, pattern|
      guess.each_with_index do |guess_color, index|
        if guess_color == pattern[index]
          response[@hint_colors[0]] += 1
        else
          unmatched[:guesses] << guess_color
          unmatched[:pattern] << pattern[index]
        end
      end
    end

    define_method :place_white_pegs do |guess, response, unmatched|
      unmatched[:guesses].each do |guess_color|
        index = unmatched[:pattern].index(guess_color)
        unless index.nil?
          unmatched[:pattern].delete_at(index)
          response[@hint_colors[1]] += 1
        end
      end
    end
  end

  class Codebreaker < Player
    # pass in space-separated list of values as one string,
    # returns each value as an array of individual symbols
    def make_guess(peg_colors, set = Mastermind::CodePeg.available_colors)
      if peg_colors.class != String
        type_err_msg = 'Please pass in a string'
        raise TypeError.new(type_err_msg)
      elsif peg_colors.include? ','
        argument_err_msg = 'Please delimit each color with a space instead of a comma'
        raise ArgumentError.new(argument_err_msg)
      end

      peg_array = peg_colors.split(' ')

      peg_array.map do |s|
        s = s.downcase.to_sym
        unless set.member?(s)
          acceptable_colors = set
          key_err_msg = "#{s} is not an available color. Please choose from:\n"
          acceptable_colors.each {|color| key_err_msg << (color.to_s << "\n")}
          raise(KeyError, key_err_msg)
        else
          s
        end
      end
    end

  end

end
