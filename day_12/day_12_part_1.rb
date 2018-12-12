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
  next_generation_pots = {}
  min_pot = pots.select { |_, plant| plant == '#' }.keys.min
  max_pot = pots.select { |_, plant| plant == '#' }.keys.max

  ((min_pot - 2)..(max_pot + 2)).each do |pot_number|
    pots_string = nearby_five_pots_string(pots, pot_number)
    next_generation_pots[pot_number] = apply_applicable_rule(rules, pots_string)
  end

  next_generation_pots
end

pots = {}
input = File.readlines('input.txt')

initial_state_string = input[0][15..-1].chomp

(0..(initial_state_string.length - 1)).each do |pot_index|
  pots[pot_index] = initial_state_string[pot_index]
end

rules = []
(2..(input.count - 1)).each do |line_number|
  rules << Rule.new(input[line_number])
end

20.times do
  pots = do_generation(pots, rules)
end

total_planted_pot_numbers = 0
pots.each do |pot_number, plant|
  total_planted_pot_numbers += pot_number if plant == '#'
end

p total_planted_pot_numbers
