class Point
  def initialize(x, y)
    @x = x.to_i
    @y = y.to_i
    @closest_point_count = 0
    @infinite = false
  end
  attr_accessor :x
  attr_accessor :y
  attr_accessor :closest_point_count
  attr_accessor :infinite
end

def find_total_distance(x, y, points)
  total_distance = 0
  points.each do |point|
    total_distance += manhattan_distance(point.x, point.y, x, y)
  end
  total_distance
end

def manhattan_distance(x0, y0, x1, y1)
  (x1 - x0).abs + (y1 - y0).abs
end

points = []
File.readlines('input.txt').each do |line|
  points << Point.new(*line.chomp.split(', '))
end

x0 = (points.map &:x).min
x1 = (points.map &:x).max
y0 = (points.map &:y).min
y1 = (points.map &:y).max

safe_region_size = 0

(x0..x1).each do |x|
  (y0..y1).each do |y|
    total_distance = find_total_distance(x, y, points)
    safe_region_size += 1 if total_distance < 10000
  end
end

p safe_region_size
