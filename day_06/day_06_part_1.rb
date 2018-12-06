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

def find_closest(x, y, points)
  closest_index = nil
  min_distance = nil
  points.each_with_index do |point, index|
    distance = manhattan_distance(point.x, point.y, x, y)
    if min_distance.nil? || min_distance > distance
      min_distance = distance
      closest_index = index
    elsif min_distance == distance
      closest_index = -1
    end
  end
  closest_index
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

(x0..x1).each do |x|
  (y0..y1).each do |y|
    index = find_closest(x, y, points)
    if index != -1
      points[index].closest_point_count += 1
      points[index].infinite = true if (x==x0 || x==x1 || y==y0 || y==y1)
    end
  end
end

p (points.select { |point| point.infinite == false }.map &:closest_point_count).max
