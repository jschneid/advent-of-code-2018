class GridCell
  def initialize(x, y, character, elf_attack_power)
    @x = x
    @y = y

    if ['G', 'E'].include?(character)
      @unit = Unit.new(character, elf_attack_power)
      @is_wall = false
    elsif character == '.'
      @is_wall = false
    else
      @is_wall = true
    end

    reset
  end

  attr_reader :x
  attr_reader :y
  attr_reader :is_wall
  attr_accessor :unit

  attr_accessor :visited
  attr_accessor :distance
  attr_accessor :previous_square_in_path

  def reset
    @visited = false
    @distance = nil
    @previous_square_in_path = nil
  end
end

class Unit
  def initialize(type, elf_attack_power)
    @hp = 200
    @type = type
    @attack_power = (type == 'G' ? 3 : elf_attack_power)
    @already_moved_this_round = false
  end

  attr_accessor :hp
  attr_accessor :attack_power
  attr_reader :type
  attr_accessor :already_moved_this_round
end

def unit_at_location(x, y, battlefield)
  battlefield.find { |square| square.x == x && square.y == y }.unit
end

def draw_battlefield(battlefield)

  print '   '
  (0..battlefield.select { |square| square.y == 0 }.count - 1).each { |i| print i % 10 }

  battlefield.each do |square|
    puts if square.x.zero?
    print '%.2i ' %square.y if square.x.zero?
    if square.unit.nil?
      print square.is_wall ? '#' : '.'
    else
      print square.unit.type
    end
  end
  puts
end

def read_battlefield_from_input_file(elf_attack_power)
  battlefield = []
  File.readlines('input.txt').each_with_index do |line, y|
    line.chomp.split('').each_with_index do |character, x|
      battlefield << GridCell.new(x, y, character, elf_attack_power)
    end
  end
  battlefield
end

def do_move(battlefield, square)
  unit = square.unit

  enemy_squares = battlefield.select { |other_square| other_square.unit != nil && other_square.unit.type != unit.type }
  enemy_distances = {}
  enemy_squares.each do |enemy_square|
    enemy_distance = min_distance(battlefield, square, enemy_square)
    enemy_distances[enemy_square] = enemy_distance unless enemy_distance.nil?

#      p "Enemy at #{enemy_square.x},#{enemy_square.y} is #{enemy_distance} away"
  end

  return square if enemy_distances.empty?

  target_square = enemy_distances.min_by{ |_enemy_square, distance| distance }.first
  return square if target_square.nil?

#    p "Closest enemy is at #{target_square.x},#{target_square.y}"

  # Set the path again
  min_distance(battlefield, square, target_square)

  return square if target_square.distance == 1

  next_square = target_square.previous_square_in_path
  until next_square.previous_square_in_path == square
    next_square = next_square.previous_square_in_path
  end

  next_square.unit = square.unit
  square.unit = nil

  p "Unit #{next_square.unit.type} moved from #{square.x},#{square.y} to #{next_square.x},#{next_square.y} heading for #{target_square.unit.type} at #{target_square.x},#{target_square.y}"
  next_square
end

# Adapted from C++ implementation at https://www.geeksforgeeks.org/shortest-distance-two-cells-matrix-grid/
def min_distance(battlefield, source_square, target_square)
  battlefield.each &:reset

  queue = []
  source_square.distance = 0
  queue.push(source_square)

  until queue.empty?
    square = queue.shift
    return square.distance if square == target_square

    evaluate_square(battlefield.find { |other_square| other_square.x == square.x && other_square.y == square.y - 1 }, queue, square, target_square)
    evaluate_square(battlefield.find { |other_square| other_square.x == square.x - 1 && other_square.y == square.y }, queue, square, target_square)
    evaluate_square(battlefield.find { |other_square| other_square.x == square.x + 1 && other_square.y == square.y }, queue, square, target_square)
    evaluate_square(battlefield.find { |other_square| other_square.x == square.x && other_square.y == square.y + 1 }, queue, square, target_square)
  end
end

def evaluate_square(square, queue, previous_square, target_square)

#  p "Checking #{square.x},#{square.y}: visited: #{square.visited} wall: #{square.is_wall} unit: #{square.unit&.type} istarget: #{square == target_square}"

  unless square.visited || square.is_wall || (square.unit && square != target_square)
    square.distance = previous_square.distance + 1
    square.visited = true
    square.previous_square_in_path = previous_square
    queue.push(square)

#    p "Square #{square.x},#{square.y} is #{square.distance} away"
  end
end

def do_attack(battlefield, square)
  enemy_square_to_attack = enemy_square_to_attack(battlefield, square)

  return false if enemy_square_to_attack.nil?

  enemy_square_to_attack.unit.hp -= square.unit.attack_power

  if enemy_square_to_attack.unit.hp <= 0
    p "Unit #{enemy_square_to_attack.unit.type} at #{enemy_square_to_attack.x},#{enemy_square_to_attack.y} died!"

    return true if enemy_square_to_attack.unit.type == 'E'

    enemy_square_to_attack.unit = nil
  end
  false
end

def enemy_square_to_attack(battlefield, square)
  adjacent_enemy_squares = adjacent_enemy_squares(battlefield, square)
  return nil if adjacent_enemy_squares.empty?

  lowest_hp = (adjacent_enemy_squares.min_by { |square| square.unit.hp }).unit.hp
  adjacent_enemy_squares_with_lowest_hp = adjacent_enemy_squares.select { |square| square.unit.hp == lowest_hp }

  return adjacent_enemy_squares_with_lowest_hp[0] if adjacent_enemy_squares_with_lowest_hp.count == 1

  min_y = (adjacent_enemy_squares.min_by { |square| square.y }).y
  adjacent_enemy_squares_at_min_y = adjacent_enemy_squares.select { |square| square.y == min_y }

  return adjacent_enemy_squares_at_min_y[0] if adjacent_enemy_squares_at_min_y.count == 1

  adjacent_enemy_squares_at_min_y.min_by &:x
end

def adjacent_enemy_squares(battlefield, square)
  adjacent_enemies = []
  square_above = battlefield.find { |other_square| other_square.x == square.x && other_square.y == square.y - 1 }
  adjacent_enemies << square_above if square_contains_enemy(square_above, square)
  square_left  = battlefield.find { |other_square| other_square.x == square.x - 1 && other_square.y == square.y }
  adjacent_enemies << square_left if square_contains_enemy(square_left, square)
  square_right = battlefield.find { |other_square| other_square.x == square.x + 1 && other_square.y == square.y }
  adjacent_enemies << square_right if square_contains_enemy(square_right, square)
  square_below = battlefield.find { |other_square| other_square.x == square.x && other_square.y == square.y + 1 }
  adjacent_enemies << square_below if square_contains_enemy(square_below, square)
  adjacent_enemies
end

def square_contains_enemy(other_square, square)
  !other_square.unit.nil? && other_square.unit.type != square.unit.type
end

def unit_types_alive(battlefield)
  unit_types_alive = {}
  battlefield.each do |square|
    unit_types_alive[square.unit.type] = true unless square.unit.nil?
  end
  unit_types_alive
end


elf_attack_power = 3
elf_died = false

loop do
  elf_attack_power += 1
  p "Increased elf attack power to #{elf_attack_power}"
  battlefield = read_battlefield_from_input_file(elf_attack_power)

  draw_battlefield(battlefield)

  rounds_complete = 0
  until unit_types_alive(battlefield).count == 1

    p "=== Round #{rounds_complete + 1} ==="

    round_ended_early = false
    at_least_one_move_performed = false

    squares_with_units = battlefield.reject { |square| square.unit.nil? }

    squares_with_units.each { |square| square.unit.already_moved_this_round = false }

    squares_with_units.each do |square|
      next if square.unit.nil?
      next if square.unit.already_moved_this_round

      if unit_types_alive(battlefield).count == 1
        round_ended_early = true
        break
      end

      square_moved_to = do_move(battlefield, square)
      elf_died = do_attack(battlefield, square_moved_to)

      break if elf_died

      square_moved_to.unit.already_moved_this_round = true
      at_least_one_move_performed = true if square != square_moved_to
    end

    break if elf_died

    draw_battlefield(battlefield) if at_least_one_move_performed

    break if round_ended_early
    rounds_complete += 1
  end

  next if elf_died

  squares_with_units = battlefield.reject { |square| square.unit.nil? }
  total_hp_left = 0
  squares_with_units.each do |square|
    total_hp_left += square.unit.hp
  end

  p rounds_complete * total_hp_left
  break
end
