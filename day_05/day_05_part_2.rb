def do_reactions(data)
  loop do
    initial_data = data
    data.split('').each_cons(2) do |pair|
      if react?(pair)
        data = data.gsub(pair.join, '')
        break
      end
    end
    return data if initial_data == data
  end
end

def react?(pair)
  pair[0] != pair[1] && pair[0].casecmp(pair[1]).zero?
end

data = File.read('input.txt')

min_length = data.length
('a'..'z').each do |polymer|
  updated_data = data.gsub(/#{polymer}/i, '')
  length = do_reactions(updated_data.chomp).length
  min_length = length if length < min_length
end

p min_length

