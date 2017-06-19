require_relative './spec_helper'

module Mastermind
  describe 'Board' do
    let(:board)   { Board.new(4, 8) }

    describe '#new' do
      it 'has 4 columns' do
        expect(board.num_columns).to eq 4
      end
      it 'has 8 rows' do
        expect(board.num_rows).to eq 8
      end
    end
  end

  describe 'GuessBoard' do
    let(:guess_board) { GuessBoard.new(4, 8) }
    let(:merv)    { Codemaker.new('merv') }
    let(:bosco)   { Codebreaker.new('bosco') }
    index = Mastermind::GuessBoard.current_turn

    describe '#receive' do
      #let(:guess) {bosco.make_guess('blue magenta yellow black')}
      let(:guess)  {[:blue, :magenta, :yellow, :black]}

      it 'will raise a TypeError if argument is not an array' do
        badly_typed_guess = {colors: [:blue, :orange, :yellow, :cyan]}
        expect{guess_board.receive(badly_typed_guess)}.to raise_error
      end
      it 'receives a player guess as an array of symbols' do
        expect(guess.all?{|g| g.class == Symbol}).to eq true
      end
      it 'returns the guess' do
        expect(guess_board.receive(guess)).to eq guess
      end
      it 'before receiving move, last value of @rows array is all nil' do
        expect(guess_board.rows.last.all?{|c| c.nil?}).to eq true
      end
      it 'will also update last value of @rows array' do
        guess_board.receive(guess)
        answer = [:blue, :magenta, :yellow, :black]
        expect(guess_board.rows[index]).to eq answer
      end
    end

    describe '#place' do
      it 'is a private method' do
        guess = bosco.make_guess('blue magenta yellow black')
        expect{guess_board.place(guess)}.to raise_error NameError
      end
      it 'receives the player guess as an array and adds to @row' do
        guess = bosco.make_guess('blue magenta yellow cyan')
        answer = [:blue, :magenta, :yellow, :cyan]
        guess_board.send(:place, guess)
        expect(guess_board.rows[index]).to eq answer
      end
    end
  end

  describe 'HintBoard' do
    let(:hint_board) { HintBoard.new(4, 8) }
    let(:merv)    { Codemaker.new('merv') }
    let(:bosco)   { Codebreaker.new('bosco') }
    preset_colors = [ :white, :black, :magenta, :yellow ]
    index = Mastermind::GuessBoard.current_turn

    describe '#receive' do
      it 'will raise a TypeError if argument is not a hash' do
        expect{hint_board.receive([])}.to raise_error TypeError
      end
      it "creates an array with passed-in Hash & updates the @rows variable via the private #place method" do
        merv.send(:set_pattern, {pattern: preset_colors})
        hint = merv.give_hint(bosco.make_guess('black white magenta blue'))
        hint_board.receive(hint)
        expect(hint_board.rows[index]).to eq [:black, :white, :white, nil]
      end
      context 'when there are no matches' do
        it 'returns an array of nil values' do
          merv.send(:set_pattern, {pattern: preset_colors})
          hint = { black: 0, white: 0}
          answer = [ nil, nil, nil, nil ]
          expect(hint_board.receive(hint)).to eq answer
        end
      end
      context 'receiving mix of white pegs & black pegs,' do
        it 'returns an array of symbols: black pegs first, then white pegs' do
          guess = 'black blue magenta yellow'
          merv.send(:set_pattern, {pattern: preset_colors})
          #hint = { black: 2, white: 1 }
          hint = merv.give_hint(bosco.make_guess(guess))
          answer  = [ :black, :black, :white, nil ]
          expect(hint_board.receive(hint)).to eq answer
        end
      end
      context 'receiving pegs of the same color,' do
        it 'returns an array of symbols' do
          guess = 'black blue yellow magenta'
          merv.send(:set_pattern, {pattern:preset_colors})
          #hint = { black: 0, white: 3 }
          hint = merv.give_hint(bosco.make_guess(guess))
          answer  = [ :white, :white, :white, nil ]
          expect(hint_board.receive(hint)).to eq answer
        end
      end
    end 
    describe '#place' do
      it 'raises TypeError when argument is not an array' do
        expect{hint_board.send(:place, {})}.to raise_error TypeError
      end
      it 'before placing the hint on the board, last value of row is nil array' do
        expect(hint_board.rows.last.all?{|v| v.nil?}).to eq true
      end
      it 'receives the player guess as an array and adds to @row' do
        guess = 'black blue cyan magenta'
        merv.send(:set_pattern, {pattern:preset_colors})
        hint = merv.give_hint(bosco.make_guess(guess))
        hint_board.send(:place, hint_board.receive(hint))
        answer = [:white, :white, nil, nil]
        expect(hint_board.rows[index]).to eq answer
      end
    end
  end

  describe 'AnswerBoard' do
    let(:answer_board) { AnswerBoard.new(4) }
    it "will not know anything about the answer until the game is over & the Codemaker tells the AnswerBoard what to print" do
    end
  end
end
