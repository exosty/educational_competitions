require_relative './spec_helper'

#module Board
  #module Printer
    describe 'Printer' do
      let(:guess_board)   { Mastermind::GuessBoard.new(4, 8) }
      let(:hint_board)    { Mastermind::HintBoard.new(4, 8) }
      let(:answer_board)  { Mastermind::AnswerBoard.new(4) }

      let(:last_row1) { [:yellow, :green, :blue, :red] }
      let(:last_row2) { [:red, :blue, :green, :yellow] }

      describe '.hello_world' do
        it 'prints contents of the constants' do
          expect(Printer.hello_world).to eq('|=-')
        end
      end

      describe '.set_horizontal_border' do
        it 'the size of each cell can be specified' do
          answer = '-----|-----|-----|-----'
          expect(Printer.set_horizontal_border(last_row1, 5, :minor)).to eq answer
        end
        it 'prints ROW_HORIZONTAL_MINOR_BORDER by default' do
          answer = '-----|-----|-----|-----'
          expect(Printer.set_horizontal_border(last_row1, 5)).to eq answer
        end
        it 'can print ROW_HORIZONTAL_MAJOR_BORDER on demand' do
          answer = '=====|=====|=====|====='
          expect(Printer.set_horizontal_border(last_row2, 5, :major)).to eq answer
        end
      end

      describe '.border_major_or_minor' do
        it 'returns ROW_HORIZONTAL_MINOR_BORDER by default' do
          expect(Printer.border_major_or_minor).to eq Printer::ROW_HORIZONTAL_MINOR_BORDER
        end
        it 'returns ROW_HORIZONTAL_MAJOR_BORDER when passed `:major`' do
          expect(Printer.border_major_or_minor(:major)).to eq Printer::ROW_HORIZONTAL_MAJOR_BORDER
        end
      end

      describe '.set_default_cell_size' do
        it 'returns a number based on the class of the passed-in board' do
          expect(Printer.set_default_cell_size(hint_board)).to eq 2
        end
      end
    end
  #end
#end
