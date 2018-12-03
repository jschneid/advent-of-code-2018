class Claim
  attr_reader :x
  attr_reader :y
  attr_reader :width
  attr_reader :height

  def initialize(line)
    numbers = line.split(/[^\d]/).reject(&:empty?)
    @x = numbers[1].to_i
    @y = numbers[2].to_i
    @width = numbers[3].to_i
    @height = numbers[4].to_i
  end
end

def count_overlaps(claims, grid)
  claims.each do |claim|
    apply_claim_to_grid(claim, grid)
  end

  count_of_grid_squares_with_overlaps(grid)
end

def apply_claim_to_grid(claim, grid)
  (claim.x..(claim.x + claim.width - 1)).each_with_index do |x|
    (claim.y..(claim.y + claim.height - 1)).each_with_index do |y|
      grid[x][y] += 1
    end
  end
end

def count_of_grid_squares_with_overlaps(grid)
  overlaps = 0
  grid.each do |row|
    row.each do |square|
      overlaps += 1 if square >= 2
    end
  end
  overlaps
end

claims = []
File.readlines('input.txt').each do |line|
  claim = Claim.new(line)
  claims << claim
end

grid = Array.new(1000) { Array.new(1000, 0) }
p count_overlaps(claims, grid)
