class Cart
  def initialize(x, y, facing)
    @x = x
    @y = y
    @facing = facing
    @next_turn = 0 # 0 == left, 1 == straight, 2 == right
    @crashed = false
  end

  attr_accessor :next_turn
  attr_accessor :x
  attr_accessor :y
  attr_accessor :facing
  attr_accessor :crashed

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

loop do
  carts.each do |cart|

    next if cart.crashed

    cart.advance_along_track(tracks)

    collided_carts = carts.select { |other_cart| other_cart.x == cart.x && other_cart.y == cart.y && !other_cart.crashed}
    next if collided_carts.count < 2

    collided_carts.each do |collided_cart|
      collided_cart.crashed = true
    end
  end

  remaining_carts = carts.reject &:crashed
  break if remaining_carts.count == 1

  # Arrange the carts in the order that they're going to move next tick
  carts.sort!
end

last_cart = carts.find { |cart| !cart.crashed }

p "#{last_cart.x}, #{last_cart.y}"
