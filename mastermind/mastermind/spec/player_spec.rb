require_relative './spec_helper'

module Mastermind
  describe 'Player' do
    let (:peterman) { Player.new('peterman') }
    it 'each player has a name' do
      expect(peterman.name).to eq 'peterman'
    end
  end

  describe 'Codemaker' do
    preset_colors = [ :white, :black, :magenta, :yellow ]
    let (:merv) { Codemaker.new('merv') }
    let (:ernest) { Codemaker.new('Ernest P World', preset_colors.length, preset_colors) }
    let (:pattern) { merv.send(:set_pattern, {pattern: preset_colors}) }

    describe '#new' do
      context 'creating a human codemaker' do
        it 'can let you manually-set the code as a human codemaker' do
          secret_pattern = ernest.instance_eval { @pattern }
          expect(secret_pattern).to eq preset_colors
        end
      end
    end
    describe '#give_hint' do
      let(:bosco) { Codebreaker.new('bosco') }

      context "Codebreaker guesses same color peg several times," do
        it "it returns no more white pegs than necessary" do
          merv.send(:set_pattern, {pattern: preset_colors})
          move = bosco.make_guess('magenta magenta magenta magenta')
          answer = {black: 1, white: 0}
          expect(merv.give_hint(move)).to eq answer
        end
      end

      context "Codebreaker guesses 0 correct" do
        it "Codemaker places no pegs" do
          merv.send(:set_pattern, {pattern: preset_colors})
          move = bosco.make_guess('red blue green cyan')
          answer = { black: 0, white: 0 }
          expect(merv.give_hint(move)).to eq answer
        end
      end
      context "Codebreaker guesses some of the correct color, but none of which are in correct position:" do
        it "Codemaker places all white key-pegs, one for each correct guess" do
          merv.send(:set_pattern, {pattern: preset_colors})
          move = bosco.make_guess('black white yellow magenta')
          answer = { black: 0, white: 4 }
          expect(merv.give_hint(move)).to eq answer
        end
      end
      context "Codebreaker guesses some of the correct color, and all of those of correct color are also in the correct position:" do
        it "Codemaker places all black key-pegs, one for each correct guess" do
          merv.send(:set_pattern, {pattern: preset_colors})
          move = bosco.make_guess('white black magenta yellow')
          answer = { black: 4, white: 0 }
          expect(merv.give_hint(move)).to eq answer
        end
      end
      context "Codebreaker guesses some of correct color & some of correct position:" do
        it "Codemaker places one black key-peg for each guess that's the correct color & the correct position" do
          merv.send(:set_pattern, {pattern: preset_colors})
          move = bosco.make_guess('blue cyan magenta yellow')
          answer = {black: 2, white: 0}
          expect(merv.give_hint(move)).to eq answer
        end
        it "Codemaker places one white key-peg for each code-peg that's the correct color but wrong position" do
          merv.send(:set_pattern, {pattern: preset_colors})
          move = bosco.make_guess('magenta yellow blue cyan')
          answer = {black: 0, white: 2}
          expect(merv.give_hint(move)).to eq answer
        end
        it "Codemaker places a mix of white key-pegs & black key-pegs" do
          merv.send(:set_pattern, {pattern: preset_colors})
          move = bosco.make_guess('black white magenta yellow')
          answer = {black: 2, white: 2}
          expect(merv.give_hint(move)).to eq answer
        end
      end

    end

    describe '#set_pattern' do
      it 'is a private method' do
        expect{merv.set_pattern}.to raise_error NameError
      end
      it 'its array length is 4 by default' do
        expect(merv.send(:set_pattern).length).to eq 4
      end
      it 'can have its array length set to something else' do
        expect(merv.send(:set_pattern, {code_length: 7}).length).to eq 7
      end
      context 'when passed nothing,' do
        it 'returns an array of CodePeg color choices, each is valid color' do
          expect(merv.send(:set_pattern).all? { |c| CodePeg.is_color_correct?(c) }).to eq true
        end
        #xit 'sets the instance variable, `@pattern` of the object' do
        #end
      end
      context 'when passed an array of symbols,' do
        it 'can be overridden by passing specific colors as symbols' do
          answer = [:white, :black, :magenta, :yellow]
          expect(pattern).to eq answer
        end
        #xit 'sets the instance variable, `@pattern` of the object' do
        #end
      end
    end

  end
  describe 'Codebreaker' do
    let(:merv) { Codemaker.new('merv') }
    let(:bosco) { Codebreaker.new('bosco') }

    it "cannot see the codemaker's pattern" do
      expect{merv.show_pattern}.to raise_error
    end

    describe '#make_guess' do
      it 'accepts a space-separated list of colors as one string, returns as an array' do
        input = 'blue white magenta yellow'
        answer = [:blue, :white, :magenta, :yellow]
        expect(bosco.make_guess(input)).to eq answer
      end
      it 'accepts an optional 2nd parameter, specifying a set of CodePeg colors to validate against' do
        optional_set = [:_1, :_2, :_3, :_4, :_5, :_6]
        input = '_1 _1 _2 _2'
        answer = [:_1, :_1, :_2, :_2]
        expect(bosco.make_guess(input, optional_set)).to eq answer
      end
      it "raises TypeError error if the values of input isn't a string" do
        input = %w(:blue, :white, :magenta, :yellow)
        expect{bosco.make_guess(input)}.to raise_error TypeError
      end
      it "raises ArgumentError error if the values of input aren't space-separated" do
        input = 'blue, white, magenta, yellow'
        expect{bosco.make_guess(input)}.to raise_error ArgumentError
      end
      it "raises KeyError error if one of the values is not found in the CodePegs.available_colors array" do
        input = 'bleu beige orAnge ywlloe'
        expect{bosco.make_guess(input)}.to raise_error KeyError
      end
    end
  end


end
