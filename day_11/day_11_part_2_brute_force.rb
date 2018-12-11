def populate_grid
  grid = Array.new(301) { Array.new(301) }
  (1..300).each do |x|
    (1..300).each do |y|
      grid[x][y] = populate_cell(x, y)
    end
  end
  grid
end

def populate_cell(x, y)
  serial_number_puzzle_input = 9424

  rack_id = x + 10
  power_level = rack_id * y
  power_level += serial_number_puzzle_input
  power_level *= rack_id
  power_level = power_level.to_s[power_level.to_s.length - 3].to_i
  power_level -= 5
  power_level
end

def find_highest_total_square(grid)
  largest_total = -10
  largest_x = 0
  largest_y = 0
  largest_size = 0

  (1..300).each do |size|
    p "Comparing squares of size #{size}, highest total so far is #{largest_total} at #{largest_x},#{largest_y} of size #{largest_size}"
    (1..(301 - size)).each do |top_left_x|
      (1..(301 - size)).each do |top_left_y|
        total = 0
        (top_left_x..(top_left_x + size - 1)).each do |x|
          (top_left_y..(top_left_y + size - 1)).each do |y|
            total += grid[x][y]
          end
        end
        next unless total > largest_total
        largest_total = total
        largest_x = top_left_x
        largest_y = top_left_y
        largest_size = size
      end
    end
  end

  p "#{largest_x}, #{largest_y}, #{largest_size}"
end

grid = populate_grid
find_highest_total_square(grid)


