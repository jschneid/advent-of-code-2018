class Instruction
  def initialize(letter)
    @letter = letter
    @predecessors = []
    @successors = []
  end
  attr_reader :letter
  attr_accessor :predecessors
  attr_accessor :successors

  def get_time
    @letter.ord - 4
  end
end

class Elf
  attr_reader :task
  attr_accessor :completion_time_index

  def get_completed_job(time_index)
    if time_index == @completion_time_index
      @completion_time_index = nil
      completed_task = @task
      @task = nil
      return completed_task
    end
    nil
  end

  def assign_task(task, current_time_index)
    @task = task
    @completion_time_index = task.get_time + current_time_index
  end
end

def get_idle_elf(elves)
  elves.find { |elf| elf.task.nil? }
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

time_index = 0
elves = Array.new(5) { Elf.new }

while executed_instructions.count < instructions.count
  loop do
    ready_instruction = get_next_instruction(potential_next_instructions, executed_instructions)

    available_elf = get_idle_elf(elves)

    break unless ready_instruction && available_elf

    available_elf.assign_task(ready_instruction, time_index)
    potential_next_instructions.delete(ready_instruction)
  end

  time_index += 1

  (elves.reject { |elf| elf.task.nil? }).each do |elf|
    completed_instruction = elf.get_completed_job(time_index)
    next if completed_instruction.nil?
    executed_instructions << completed_instruction
    potential_next_instructions += completed_instruction.successors
    potential_next_instructions = potential_next_instructions.uniq
  end
end

p time_index
