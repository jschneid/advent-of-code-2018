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

  (1..300).each do |top_left_x|
    (1..300).each do |top_left_y|
      total = grid[top_left_x][top_left_y]
      size = 1
      right_edge_x = top_left_x
      bottom_edge_y = top_left_y

      while right_edge_x < 300 && bottom_edge_y < 300
        (top_left_y..bottom_edge_y).each do |y|
          total += grid[right_edge_x + 1][y]
        end
        (top_left_x..right_edge_x).each do |x|
          total += grid[x][bottom_edge_y + 1]
        end
        total += grid[right_edge_x + 1][bottom_edge_y + 1]

        if total > largest_total
          largest_total = total
          largest_x = top_left_x
          largest_y = top_left_y
          largest_size = size + 1
        end

        size += 1
        right_edge_x += 1
        bottom_edge_y += 1
      end
    end
  end

  p "#{largest_x}, #{largest_y}, #{largest_size}"
end

grid = populate_grid
find_highest_total_square(grid)


