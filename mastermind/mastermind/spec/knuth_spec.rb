require_relative './spec_helper'

module Mastermind
  describe 'Knuth' do
    let(:palette) { Mastermind::CodePeg.available_colors }
    let(:key_size) { 4 }
    let(:dk) { Knuth.new('donald knuth', key_size, palette) }
    let(:bigger_codebreaker) {Knuth.new('Heavy', 5, palette)}
    #dk.history.each{|a| print a; puts}

    describe '#proto_guess' do
      context 'when @history is empty' do
      end
    end

    describe '#make_initial_guess' do
      it 'is a private method, should raise an error if called directly' do
        expect{bigger_codebreaker.make_initial_guess}.to raise_error NameError
      end
      it 'returns an initial guess where 1st half of the values are same as each other. 2nd half are same as each other' do
        ig = bigger_codebreaker.send(:make_initial_guess)
        def test(arr)
          halfway_index = (arr.length / 2.0).ceil
          arr1 = arr[0...halfway_index]
          arr2 = arr[halfway_index..arr.length]
        
          all_same1 = arr1.all? {|c| c == arr[0]}
          all_same2 = arr2.all? {|c| c == arr[halfway_index]}
        
          all_same1 and all_same2
        end
        expect(test(ig)).to be_truthy
      end
    end
    describe '#add_guess_to_history' do
      it 'validates guess & adds it to @history' do
        ig = dk.proto_guess()
        dk.add_guess_to_history(ig)
        expect(dk.history.last).to match_array ig
      end
      it 'raises an error when at least one value is not valid' do
        bad_guess = [:snozzberry, :not_a_color, :psych, :not_a_color_either]
        expect{dk.add_guess_to_history(bad_guess)}.to raise_error KeyError
      end
    end

    describe 'comparing functions' do
      describe 'accessibility' do
        it 'are private methods, would raise an error if called normally' do
          expect{dk.count_hits(g1, g2)}.to raise_error NameError
          expect{dk.count_same_color_and_position(g1, g2)}.to raise_error NameError
          expect{dk.count_same_color_but_wrong_position(g1, g2)}.to raise_error NameError
        end
      end

      let (:g1) { [:white, :red, :yellow, :cyan] }
      let (:g2) { [:cyan, :yellow, :black, :white] }
      let (:g3) { [:cyan, :cyan, :red, :red] }
      let (:g4) { [:red, :yellow, :black, :white] }
      let (:g5) { [:murple, :murple, :snozzberry, :snozzberry] }

      describe '#count_hits' do
        it 'counts how many values in one array exist in another' do
          expect(dk.send(:count_hits, g1, g2)).to eq 3
        end
        it 'will not count duplicates' do
          expect(dk.send(:count_hits, g3, g4)).to eq 1
          expect(dk.send(:count_hits, g4, g3)).to eq 1
        end
      end
      describe '#count_same_color_and_position' do
        it 'counts number of values in same color & position' do
          expect(dk.send(:count_same_color_and_position, g2, g4)).to eq 3
          expect(dk.send(:count_same_color_and_position, g2, g3)).to eq 1
          expect(dk.send(:count_same_color_and_position, g1, g5)).to eq 0
          expect(dk.send(:count_same_color_and_position, g1, g3)).to eq 0
        end
      end
      describe '#count_same_color_but_wrong_position' do
        it 'counts number of values in same color but wrong position' do
          expect(dk.send(:count_same_color_but_wrong_position, g3, g1)).to eq 2
        end
      end
    end

    describe '#score' do
      let(:merv) { Codemaker.new('merv') }
      let(:guess1) { [:black, :black, :white, :white] }
      let(:hint_from_codemaker) { merv.give_hint(guess1) }
      it 'is a private method, should raise an error if called directly' do
        expect{dk.score(guess1, stolen_secret_code)}.to raise_error NameError
      end
      it 'compares 1 guess to another guess returns a score as a Hash object' do
        stolen_secret_code = merv.send(:show_pattern)
        expect(dk.send(:score, guess1, stolen_secret_code)).to eq hint_from_codemaker
      end
    end

  end
end
