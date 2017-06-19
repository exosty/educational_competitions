module Printer
  require 'colorize'

  ROW_HORIZONTAL_MAJOR_BORDER = '='
  ROW_HORIZONTAL_MINOR_BORDER = '-'
  ROW_INTRA_CELL_BORDER = '|'

  def self.hello_world
    constant = ''
    constant << ROW_INTRA_CELL_BORDER
    constant << ROW_HORIZONTAL_MAJOR_BORDER
    constant << ROW_HORIZONTAL_MINOR_BORDER
  end

  def self.print_board(board)
    # meant for boards processed via Printer.merge_two_boards
    if board.class == Array
      board.each do |row|
        puts row
      end
    else # meant for singular boards
      cell_size = Printer.set_default_cell_size(board)
      board.rows.each do |row|
        puts self.set_horizontal_border(row, cell_size)
        puts self.get_row_contents(row, cell_size)
      end
    end
  end

  # pass in two board objects, extract respective @rows array.
  # return a combination of the two as a new array
  def self.merge_two_boards(options)
    b1 = options[:guess_board]
    b2 = options[:hint_board]
    b1_cell_size = options[:b1_cell_size] || Printer.set_default_cell_size(b1)
    b2_cell_size = options[:b2_cell_size] || Printer.set_default_cell_size(b2)

    spacer = self.initiate_cell(4)
    new_board = []

    b1.rows.each_with_index do |row, ind|
      border = ''
      b1_border = self.set_horizontal_border(b1.rows[ind], b1_cell_size)
      b2_border = self.set_horizontal_border(b2.rows[ind], b2_cell_size)
      border << (b1_border << spacer << b2_border)
      new_board.push(border)

      contents = ''
      b1_contents = self.get_row_contents(b1.rows[ind], b1_cell_size)
      b2_contents = self.get_row_contents(b2.rows[ind], b2_cell_size)
      contents << (b1_contents << spacer << b2_contents)
      new_board.push(contents)
    end
    new_board
  end

  def self.set_horizontal_border(row, cell_size, major_or_minor = nil)
    major_or_minor = self.border_major_or_minor(major_or_minor)

    border = []
    row.each do |val|
      cell_top = ''
      cell_size.times { cell_top << major_or_minor }
      border << cell_top
    end
    border.join(ROW_INTRA_CELL_BORDER)
  end

  # good idea to save results of this function into its own variable
  # to concatenate its output into growing string leads to problems
  # ex: `contents << self.get_row_contents(r1, 3)` 
  # will be over-written by subsequent uses of shovel operator
  # if you do this: `contents << self.get_row_contents(another_row, 1)`
  # `contents` is now the value of `another_row` only, not `r1 << another_row`
  #
  # recommended to do this instead:
  # ex: `r1_output = self.get_row_contents(r1, 3)`
  # then use the shovel operator: `contents << r1_output`
  def self.get_row_contents(row, cell_size)
    contents = []
    row.each do |val|
      if val == :black || val == :white
        str = cell_size % 2 == 0 ? val.to_s[0..1] : val.to_s[0]
        cell = self.initiate_cell(cell_size, str.capitalize)
      else
        cell = self.initiate_cell(cell_size)
      end
      contents << cell.colorize(:background => val)
    end
    contents.join(ROW_INTRA_CELL_BORDER)
  end

  def self.initiate_cell(size, contents = '')
    #size.times { contents << ' ' }
    contents.center(size)
  end

  def self.border_major_or_minor(major_or_minor = nil)
    case major_or_minor
    when :major
      major_or_minor = ROW_HORIZONTAL_MAJOR_BORDER
    when nil, :minor
      major_or_minor = ROW_HORIZONTAL_MINOR_BORDER
    end
    major_or_minor
  end

  def self.set_default_cell_size(board)
    case board.class.to_s
    when 'Mastermind::GuessBoard', 'Mastermind::AnswerBoard'
      4
    when 'Mastermind::HintBoard'
      2
    else
      2
    end
  end

  def self.print_error_message(e)
    def self.grow_marker n
      str = ''
      n.times { str << '*' }
      str
    end
    msg = (e.class.to_s << ": " << e.message.to_s)
    n = msg.length
    marker = self.grow_marker(n)
    puts
    print marker.center(n)
    puts
    print msg.center(n)
    puts
    print marker.center(n)
  end

end
