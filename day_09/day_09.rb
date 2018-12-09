class Marble
  attr_reader :value
  attr_accessor :next_marble_clockwise
  attr_accessor :next_marble_counterclockwise

  def initialize(value)
    @value = value
  end

  def remove
    @next_marble_clockwise.next_marble_counterclockwise = @next_marble_counterclockwise
    @next_marble_counterclockwise.next_marble_clockwise = @next_marble_clockwise
  end
end

class Game
  def initialize
    @player_count = 439 # from my personal input
    @last_marble = 7130700 # from my personal input

    @current_marble = Marble.new(0)
    @current_marble.next_marble_clockwise = @current_marble
    @current_marble.next_marble_counterclockwise = @current_marble

    @player_scores = Array.new(@player_count, 0)
    @marble_value = 1
    @current_player = 1
  end

  def insert_marble(value, next_marble_clockwise, next_marble_counterclockwise)
    marble = Marble.new(value)
    marble.next_marble_clockwise = next_marble_clockwise
    next_marble_clockwise.next_marble_counterclockwise = marble
    marble.next_marble_counterclockwise = next_marble_counterclockwise
    next_marble_counterclockwise.next_marble_clockwise = marble
    @current_marble = marble
  end

  def score_marble
    score = @marble_value
    marble_to_score_and_remove = @current_marble
    7.times { marble_to_score_and_remove = marble_to_score_and_remove.next_marble_counterclockwise }

    score += marble_to_score_and_remove.value

    @current_marble = marble_to_score_and_remove.next_marble_clockwise

    marble_to_score_and_remove.remove

    @player_scores[@current_player] += score
    score
  end

  def play
    loop do
      if (@marble_value % 23).zero?
        score_marble
      else
        insert_marble(@marble_value, @current_marble.next_marble_clockwise.next_marble_clockwise, @current_marble.next_marble_clockwise)
      end

      break if @marble_value == @last_marble

      @current_player = (@current_player + 1) % @player_count
      @marble_value += 1
    end

    p @player_scores.max
  end
end

Game.new.play



