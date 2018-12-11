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
  largest_total = -100
  largest_x = 0
  largest_y = 0

  (1..298).each do |top_left_x|
    (1..298).each do |top_left_y|
      total = 0
      (top_left_x..(top_left_x + 2)).each do |x|
        (top_left_y..(top_left_y + 2)).each do |y|
          total += grid[x][y]
        end
      end
      next unless total > largest_total
      largest_total = total
      largest_x = top_left_x
      largest_y = top_left_y
    end
  end

  p "#{largest_x}, #{largest_y}"
end

grid = populate_grid
find_highest_total_square(grid)


