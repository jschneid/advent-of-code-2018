def combine_recipes(elf_positions, recipes, puzzle_input)
  recipe_total = 0
  elf_positions.each do |position|
    recipe_total += get_recipe_at_position(recipes, position).to_i
  end

  if recipe_total <= 9
    add_recipe(recipes, recipe_total.to_s)
  else
    add_recipe(recipes, recipe_total.to_s[0])
    return recipes if match_found(recipes, puzzle_input)
    add_recipe(recipes, recipe_total.to_s[1])
  end
  recipes
end

def add_recipe(recipes, recipe)
  if recipes[recipes.count - 1].length < @chunk_size
    recipes[recipes.count - 1] << recipe
  else
    recipes << recipe
  end
end

def get_recipe_at_position(recipes, position)
  return recipes[position / @chunk_size][position % @chunk_size]
end

def recipes_length(recipes)
  (recipes.count - 1) * @chunk_size + recipes[recipes.count - 1].length
end

def update_elf_positions(elf_positions, recipes)
  elf_positions.each_with_index do |position, elf_index|
    advance_distance = 1 + get_recipe_at_position(recipes, position).to_i
    elf_positions[elf_index] = (position + advance_distance) % recipes_length(recipes)
  end
end

def match_found(recipes, puzzle_input)
  return false if recipes_length(recipes) < puzzle_input.length

  last_chunk_length = recipes[recipes.count - 1].length

  return recipes[recipes.count - 1].end_with?(puzzle_input) if last_chunk_length >= puzzle_input.length

  recipes[recipes.count - 1] == puzzle_input[((last_chunk_length - 1) * -1)..-1] &&
    recipes[recipes.count - 2][((last_chunk_length - 1) * -1)..-1] == puzzle_input[0..(puzzle_input.length - last_chunk_length - 1)]
end

recipes = ['37']
elf_positions = [0, 1]
puzzle_input = '190221'

# Ruby's performance starts to become terrible once the recipes string (or array of ints, or int with base 10 representation)
# starts getting really long, so this solution breaks that string into 10000-character chunks to avoid those perf issues.
@chunk_size = 10000

until match_found(recipes, puzzle_input)
  recipes = combine_recipes(elf_positions, recipes, puzzle_input)
  update_elf_positions(elf_positions, recipes)
end

p recipes_length(recipes) - puzzle_input.length
