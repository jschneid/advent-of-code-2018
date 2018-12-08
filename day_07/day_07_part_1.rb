class Instruction
  def initialize(letter)
    @letter = letter
    @predecessors = []
    @successors = []
  end
  attr_reader :letter
  attr_accessor :predecessors
  attr_accessor :successors
end

def get_instruction(instructions, letter)
  existing_instruction = instructions.find{|instruction| instruction.letter == letter}
  return existing_instruction if existing_instruction
  new_instruction = Instruction.new(letter)
  instructions << new_instruction
  new_instruction
end

def get_next_instruction(potential_next_instructions, executed_instructions)
  eligible_next_instructions = potential_next_instructions.map &:letter

  potential_next_instructions.each do |potential_next_instruction|
    potential_next_instruction.predecessors.each do |predecessor|
      eligible_next_instructions.delete(potential_next_instruction.letter) if executed_instructions.find { |i| i.letter == predecessor.letter }.nil?
    end
  end

  potential_next_instructions.find { |i| i.letter == eligible_next_instructions.sort.first }
end

instructions = []
File.readlines('input.txt').each do |line|
  first_letter = line[5]
  second_letter = line[36]

  before = get_instruction(instructions, first_letter)
  after = get_instruction(instructions, second_letter)

  after.predecessors << before
  before.successors << after
end

potential_next_instructions = instructions.select { |instruction| instruction.predecessors.empty? }
executed_instructions = []

loop do
  next_instruction = get_next_instruction(potential_next_instructions, executed_instructions)
  break unless next_instruction
  executed_instructions << next_instruction
  potential_next_instructions.delete(next_instruction)
  potential_next_instructions += next_instruction.successors
  potential_next_instructions = potential_next_instructions.uniq
end

p (executed_instructions.map &:letter).join
