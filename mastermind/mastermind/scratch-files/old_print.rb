module Printer
  ROW_TOP_BOTTOM_BORDER = '----'
  ROW_LEFT_RIGHT_BORDER = '|'
  def self.print_row rows
    top = (rows.length).times { '' << ROW_TOP_BOTTOM_BORDER }
    puts top
    rows.each_with_index do |val, index|
      Kernel.print ' ', val, ' ', ROW_LEFT_RIGHT_BORDER
    end
    puts
  end
end

module Mastermind
  class Board
    include Printer
    attr_reader :num_columns, :num_rows, :rows

    def initialize(num_columns, num_rows)
      @num_columns = num_columns
      @num_rows = num_rows
      @rows = reset_rows(@num_columns, @num_rows)
    end

    def reset_rows(num_columns, num_rows)
      rows = []
      num_rows.times { rows << Array.new(num_columns) }
      rows
    end
  end
end


my_board = Mastermind::Board.new(8,4)
Printer.print_row(my_board.rows)
my_board.rows.last.map! {|v| :red }
Printer.print_row(my_board.rows)
