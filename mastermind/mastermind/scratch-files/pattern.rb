require_relative '../lib/peg.rb'
require_relative '../lib/player.rb'

merv = Mastermind::Codemaker.new('merv')
pattern = merv.send(:make_pattern)
puts pattern
arr = [:white, :black, :orange, :yellow]
puts merv.make_pattern
