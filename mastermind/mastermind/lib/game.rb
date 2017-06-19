module Mastermind
  class Game

    attr_reader :current_turn, :total_turns, :num_of_setup_steps, :settings,
      :code_length, :maker, :breaker,
      :guess_board, :hint_board, :answer_board
    
    @@current_turn = 0

    def initialize(args)
      args[:total_turns] ||= 8
      args[:code_length] ||= 4

      @maker = Codemaker.new(args[:maker], args[:code_length], args[:pattern])
      case args[:human_or_ai_codebreaker]
      when :ai
        palette = CodePeg.available_colors
        @breaker = Knuth.new(args[:breaker], args[:code_length], palette)
      else
        @breaker = Codebreaker.new(args[:breaker])
      end

      @total_turns = args[:total_turns]
      @code_length = args[:code_length]

      @guess_board = GuessBoard.new(@code_length, @total_turns)
      @hint_board = HintBoard.new(@code_length, @total_turns)
      @answer_board = AnswerBoard.new(@code_length)
    end

    def play()
      print_intro()
      is_game_over = false
      while not is_game_over
        do_one_turn()
        is_game_over = check_game_over()
        @@current_turn += 1
      end
      print_outcome(is_game_over)
    end

    def print_updated_boards()
      merged = Printer.merge_two_boards({
        guess_board: @guess_board, hint_board: @hint_board
      })
      Printer.print_board(merged)
    end

    def self.current_turn()
      @@current_turn
    end

    def self.get_settings(prompt = nil)
      @settings = {}
      puts
      if prompt
        i = 1
        @num_of_setup_steps = 6
        puts "OK, customizing settings"
        puts
        # Step 1: get name for Codemaker
        get_name(i, :maker)
        i+=1
        # Step 2: ask if Codemaker is a human or AI player.
        human_or_ai = ask_human_or_ai(i)
        i+=1
        # Step 3a: if Codemaker is a human
        # OR
        # Step 3b: if the Codemaker is not a human
        codemaker_setup(i, human_or_ai)
        i+=1
        # Step 4: get name for Codebreaker
        get_name(i, :breaker)
        i+=1
        # Step 5: ask if Codebreaker is human or AI player
        # Step 5a: if Codebreaker is a AI
        # OR
        # Step 5b: if the Codebreaker is not a human
        human_or_ai = ask_human_or_ai(i)
        codebreaker_setup(human_or_ai)
        i+=1
        # Step 6: ask how many turns the Codebreaker has
        get_number_of_turns(i)
      else
        puts "Playing with default settings"
        @settings[:maker] = 'Mordecai Meirowitz'
        @settings[:breaker] = 'Boris Grishenko'
      end
      @settings
    end

    def self.get_name (i, role)
      if role == :maker
        puts "Step #{i}/#{@num_of_setup_steps}: Enter the name of the Codemaker"
        @settings[:maker] = gets.chomp
      elsif role == :breaker
        puts "Step #{i}/#{@num_of_setup_steps}: Enter the name of Codebreaker"
        @settings[:breaker] = gets.chomp
      end
    end
    
    def self.ask_human_or_ai (i)
      puts "Step #{i}/#{@num_of_setup_steps}: Is this a human or a robot?"
      gets.chomp.downcase.to_sym
    end

    def self.codemaker_setup (i, human_or_ai)
      case human_or_ai
      when :human
        puts "the Codemaker is a human"
        begin
          puts "Step #{i}/#{@num_of_setup_steps}: Enter a secret code"
          code = Codebreaker.new('').instance_eval {self.make_guess(gets.chomp)}
        rescue StandardError => e
          puts Printer.print_error_message(e)
          retry
        else
          @settings[:pattern] = code
          @settings[:code_length] = code.length
        end
      else
        puts "the Codemaker is AI"
        begin
          puts "Step #{i}/#{@num_of_setup_steps}: How many characters long is the secret code?"
          n = gets.chomp.to_i
          is_code_length_valid?(n)
        rescue ArgumentError => e
          puts Printer.print_error_message(e)
          retry
        else
          @settings[:code_length] = n
        end
      end
    end
    
    def self.codebreaker_setup (human_or_ai)
      case human_or_ai
      when :robot, :ai
        @settings[:human_or_ai_codebreaker] = :ai
        puts "the Codebreaker is AI"
      else
        @settings[:human_or_ai_codebreaker] = :human
        puts "the Codebreaker is a human"
      end
    end

    def self.get_number_of_turns (i)
      begin
        puts "Step #{i}/#{@num_of_setup_steps}: How many turns will the Codebreaker have?"
        n = gets.chomp.to_i
        is_total_turns_valid?(n)
      rescue ArgumentError => e
        puts Printer.print_error_message(e)
        retry
      else
        @settings[:total_turns] = n
      end
    end

    def self.is_code_length_valid?(num)
      # must be (1..Knuth.limit)
      num = (num >= 1 && num <= Knuth.limit) ?
        num :
        raise(ArgumentError, "Must be >= 1 and <= #{Knuth.limit}")
    end

    def self.is_total_turns_valid?(num)
      # must be an even number. must be (4..12)
      num = (num % 2 == 0 && num >= 4 && num <= 12) ?
        num :
        raise(ArgumentError, "Must be an even number where n >= 4 and n <= 12")
    end

    private_class_method :get_name, :ask_human_or_ai,
      :codemaker_setup, :codebreaker_setup, :get_number_of_turns,
      :is_code_length_valid?, :is_total_turns_valid?

    private
    def do_one_turn()
      begin
        puts
        puts "You are on turn ##{(@@current_turn + 1)} of #{total_turns}"
        puts "You have #{@total_turns - @@current_turn} turns remaining (including the current turn)"
        puts
        print_updated_boards()
        puts
        puts "#{@breaker.name}: Enter a list of #{@code_length} colors separated by spaces."
        if @breaker.class == Knuth
          guess = @breaker.proto_guess()
          @breaker.add_guess_to_history(guess)
          @breaker.remove_from_narrowed_set(@maker.give_hint(guess))
          sleep(1.5)
        elsif @breaker.class == Codebreaker
          guess = @breaker.make_guess(gets.chomp)
        end
      rescue StandardError => e
        puts Printer.print_error_message(e)
        retry
      else
        @guess_board.receive(guess)
        hint = @maker.give_hint(guess)
        @hint_board.receive(hint)
        puts "You guessed: #{guess}"
        puts "The hint: #{hint}"
      end
    end

    def print_intro()
      puts
      puts '**************'
      puts 'Beginning Play'
      puts '**************'
      puts "Codemaker:        #{@maker.name}"
      puts "Codebreaker:      #{@breaker.name}"
      puts "Number of Turns:  #{@total_turns}"
      puts "Code Length:      #{@code_length}"
    end

    def print_outcome(outcome)
      puts
      print_updated_boards()
      puts
      puts "GAME OVER"
      case outcome
      when :win
        puts "You win #{@breaker.name}!"
      when :loss
        puts "You lose #{@breaker.name}!"
      end
      puts "Here is the answer:"
      reveal_answer()
      Printer.print_board(@answer_board)
    end

    def check_game_over()
      return :win if @hint_board.rows[@@current_turn].all?{|peg| peg == :black}
      # comparing @@current_turn to @total_turns - 1 
      # because @@current_turn is incremented after we call `check_game_over`
      return :loss if @@current_turn >= (@total_turns - 1)
      false
    end

    def reveal_answer()
      @answer_board.receive(@maker.send(:show_pattern))
    end

  end
end
