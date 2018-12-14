def combine_recipes(elf_positions, recipes)
  recipe_total = 0
  elf_positions.each do |position|
    recipe_total += recipes[position]
  end

  if recipe_total <= 9
    recipes << recipe_total
  else
    recipes << recipe_total.to_s[0].to_i
    recipes << recipe_total.to_s[1].to_i
    end
end

def update_elf_positions(elf_positions, recipes)
  elf_positions.each_with_index do |position, elf_index|
    advance_distance = 1 + recipes[position]
    elf_positions[elf_index] = (position + advance_distance) % recipes.count
  end
end

recipes = [3, 7]
elf_positions = [0, 1]

puzzle_input = 190221
until recipes.count == (puzzle_input + 10)
  combine_recipes(elf_positions, recipes)
  update_elf_positions(elf_positions, recipes)
end

(0..9).each do |index|
  print recipes[recipes.count - 10 + index]
end
