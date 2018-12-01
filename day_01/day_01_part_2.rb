def find_first_repeated_frequency
  frequencies_seen = {}
  frequency = 0

  loop do
    File.readlines('input.txt').each do |line|
      frequency += line.to_i
      return frequency if frequencies_seen.has_key?(frequency)
      frequencies_seen[frequency] = true
    end
  end
end

puts find_first_repeated_frequency
