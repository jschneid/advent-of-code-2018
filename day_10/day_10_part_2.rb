def draw_points(points, min_x, max_x, min_y, max_y, seconds)
  puts "[#{seconds}]"
  for y in min_y..max_y do
    for x in min_x..max_x do
      if points.find { |point| point[0] == x && point[1] == y }
        print '#'
      else
        print '.'
      end
    end
    puts ''
  end
  puts ''
end

points = File.readlines('input.txt').map { |line| line.scan(/-?\d+/).map(&:to_i) }

converged = false
seconds = 0

loop do
  points.each do |point|
    point[0] += point[2]
    point[1] += point[3]
  end
  seconds += 1

  min_x = points.map { |point| point[0] }.min
  max_x = points.map { |point| point[0] }.max
  min_y = points.map { |point| point[1] }.min
  max_y = points.map { |point| point[1] }.max

  was_converged = converged
  converged = (max_y - min_y).abs < 100 && (max_x - min_x).abs < 100

  break if !converged && was_converged

  draw_points(points, min_x, max_x, min_y, max_y, seconds) if converged
end


