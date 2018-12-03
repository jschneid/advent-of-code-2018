class Claim
  attr_reader :id
  attr_reader :x
  attr_reader :y
  attr_reader :width
  attr_reader :height

  def initialize(line)
    numbers = line.split(/[^\d]/).reject(&:empty?)
    @id = numbers[0].to_i
    @x = numbers[1].to_i
    @y = numbers[2].to_i
    @width = numbers[3].to_i
    @height = numbers[4].to_i
  end
end

def get_unoverlapped_claim(claims, grid, unoverlapped_claims)
  claims.each do |claim|
    apply_claim_to_grid(claim, grid, unoverlapped_claims)
  end

  unoverlapped_claims[0].id
end

def apply_claim_to_grid(claim, grid, unoverlapped_claims)
  (claim.x..(claim.x + claim.width - 1)).each_with_index do |x|
    (claim.y..(claim.y + claim.height - 1)).each_with_index do |y|

      if grid[x][y] > 0
        remove_unoverlapped_claim_with_id(unoverlapped_claims, claim.id)
        remove_unoverlapped_claim_with_id(unoverlapped_claims, grid[x][y])
      end

      grid[x][y] = claim.id
    end
  end
end

def remove_unoverlapped_claim_with_id(unoverlapped_claims, id)
  unoverlapped_claims.delete_if { |claim| claim.id == id }
end

claims = []
File.readlines('input.txt').each do |line|
  claim = Claim.new(line)
  claims << claim
end

unoverlapped_claims = claims.dup

grid = Array.new(1000) { Array.new(1000, 0) }
p get_unoverlapped_claim(claims, grid, unoverlapped_claims)

