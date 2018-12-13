class Rule
  def initialize(rule_line)
    @rule_string = rule_line[0..4]
    @rule_output = rule_line[9]
  end

  attr_reader :rule_string
  attr_reader :rule_output
end

def nearby_five_pots_string(pots, center_pot_number)
  pots_string = ''
  ((center_pot_number - 2)..(center_pot_number + 2)).each do |pot_number|
    pots_string += pots[pot_number] == '#' ? '#' : '.'
  end
  pots_string
end

def apply_applicable_rule(rules, pots_string)
  rules.each do |rule|
    return rule.rule_output if rule.rule_string == pots_string
  end
end

def do_generation(pots, rules)
  next_generation_pots = Hash.new('.')
  min_pot = pots.select { |_, plant| plant == '#' }.keys.min
  max_pot = pots.select { |_, plant| plant == '#' }.keys.max

  ((min_pot - 2)..(max_pot + 2)).each do |pot_number|
    pots_string = nearby_five_pots_string(pots, pot_number)
    plant = apply_applicable_rule(rules, pots_string)
    next_generation_pots[pot_number] = '#' if plant == '#'
  end

  next_generation_pots
end

def get_pots_string(pots)
  pots_string = ''

  min_pot = pots.select { |_, plant| plant == '#' }.keys.min
  max_pot = pots.select { |_, plant| plant == '#' }.keys.max
  (min_pot..max_pot).each do |pot_number|
    pots_string += pots[pot_number] == '#' ? '#' : '.'
  end
  pots_string
end

def translate_pots(pots, amount)
  pots.keys.each do |pot_index|
    pots[pot_index + amount] = pots[pot_index]
    pots.delete(pot_index)
  end
  pots
end

pots = Hash.new('.')
input = File.readlines('input.txt')

initial_state_string = input[0][15..-1].chomp

(0..(initial_state_string.length - 1)).each do |pot_index|
  pots[pot_index] = initial_state_string[pot_index]
end

rules = []
(2..(input.count - 1)).each do |line_number|
  rules << Rule.new(input[line_number])
end

generations = []
pots_string = get_pots_string(pots)
generations << pots_string
generation_start_pot_indices = []
generation_start_pot_indices << pots.select { |_, plant| plant == '#' }.keys.min

until generations.count(pots_string) == 2
  pots = do_generation(pots, rules)
  pots_string = get_pots_string(pots)

  generations << pots_string
  generation_start_pot_indices << pots.select { |_, plant| plant == '#' }.keys.min
end

# I know from running the program with my input that the cycle length is 1, so no need to write code
# to account for other cycle lengths.

remaining_years = 50000000000 - (generations.count - 1)

pots = translate_pots(pots, remaining_years)

total_planted_pot_numbers = 0
pots.each do |pot_number, plant|
  total_planted_pot_numbers += pot_number if plant == '#'
end
p total_planted_pot_numbers
