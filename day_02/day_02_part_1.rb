def checksum(lines)

  double_occurrences = 0
  triple_occurrences = 0

  lines.each do |line|
    found_double_occurrence = false
    found_triple_occurrence = false

    ('a'..'z').each do |letter|
      found_double_occurrence = true if line.count(letter) == 2
      found_triple_occurrence = true if line.count(letter) == 3
      break if found_double_occurrence && found_triple_occurrence
    end

    double_occurrences += 1 if found_double_occurrence
    triple_occurrences += 1 if found_triple_occurrence
  end

  double_occurrences * triple_occurrences
end



File.open('input.txt') do |lines|
  p checksum(lines)
end
