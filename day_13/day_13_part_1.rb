class Cart
  def initialize(x, y, facing)
    @x = x
    @y = y
    @facing = facing
    @next_turn = 0 # 0 == left, 1 == straight, 2 == right
  end

  attr_accessor :next_turn
  attr_accessor :x
  attr_accessor :y
  attr_accessor :facing

  def <=>(other)
    (@y * 1000) + @x <=> (other.y * 1000) + other.x
  end

  def advance_along_track(tracks)
    move_forward
    turn(tracks)
  end

  private

  def move_forward
    case @facing
    when '^'
      @y -= 1
    when '>'
      @x += 1
    when 'v'
      @y += 1
    when '<'
      @x -= 1
    end
  end

  def turn(tracks)
    case tracks[@x][@y]
    when '/'
      if @facing == '<' || @facing == '>'
        turn_left
      else
        turn_right
      end
    when '\\'
      if @facing == '^' || @facing == 'v'
        turn_left
      else
        turn_right
      end
    when '+'
      if @next_turn == 0
        turn_left
      elsif @next_turn == 2
        turn_right
      end
      @next_turn = ((@next_turn + 1) % 3)
    end
  end

  def turn_right
    case @facing
    when '^'
      @facing = '>'
    when '>'
      @facing = 'v'
    when 'v'
      @facing = '<'
    when '<'
      @facing = '^'
    end
  end

  def turn_left
    case @facing
    when '^'
      @facing = '<'
    when '>'
      @facing = '^'
    when 'v'
      @facing = '>'
    when '<'
      @facing = 'v'
    end
  end
end


tracks = Array.new(150) { Array.new(150, ' ') }
carts = []
File.readlines('input.txt').each_with_index do |line, y|
  line.chomp.split('').each_with_index do |character, x|
    case character
    when '^', 'v'
      carts << Cart.new(x, y, character)
      tracks[x][y] = '|'
    when '<', '>'
      carts << Cart.new(x, y, character)
      tracks[x][y] = '-'
    else
      tracks[x][y] = character
    end
  end
end

collision_found = false

loop do
  carts.each do |cart|
    cart.advance_along_track(tracks)

    next if carts.select { |other_cart| other_cart.x == cart.x && other_cart.y == cart.y }.count < 2

    p "#{cart.x}, #{cart.y}"
    collision_found = true
    break
  end

  break if collision_found

  # Arrange the carts in the order that they're going to move next tick
  carts.sort!
end
