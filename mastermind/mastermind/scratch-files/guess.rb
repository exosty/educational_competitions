g1 = [:white, :red, :yellow, :cyan]
g2 = [:cyan, :yellow, :black, :white]
g3 = [:cyan, :cyan, :red, :red]
g4 = [:red, :yellow, :black, :white]

def stricly_count(arr1, arr2)
  i = 0
  arr1.inject do |count, value|
    count += 1 if arr1[i] == arr2[i]
    i += 1
  end
end

puts stricly_count(g1, g2)
puts stricly_count(g3, g4)
