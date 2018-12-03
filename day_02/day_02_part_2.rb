def find_matching_letters(lines)
  lines.combination(2) do |word, word2|
    common_letters = get_common_letters(word.chomp, word2.chomp)
    return common_letters if common_letters.length == word.chomp.length - 1
  end
end

def get_common_letters(word1, word2)
  matching_letters = ''
  word1.each_char.with_index do |letter, index|
    matching_letters += letter if letter == word2[index]
  end
  matching_letters
end

p find_matching_letters(File.readlines('input.txt'))

