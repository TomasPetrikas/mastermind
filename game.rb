# frozen_string_literal: true

require_relative 'board'
require_relative 'display'
require_relative 'player'
require_relative 'computer_player'

# Controller for the actual game
class Game
  # Represents different difficulty levels
  MAX_TURNS = [12, 10, 8].freeze

  def initialize
    @display = Display.new
  end

  def start
    @display.clear_screen
    @display.intro
    @game_mode = game_mode
    @display.difficulty
    @difficulty = difficulty

    @board = Board.new(MAX_TURNS[@difficulty - 1])

    mode_maker if @game_mode == 1
    mode_breaker if @game_mode == 2
  end

  private

  def game_mode
    loop do
      mode = gets.chomp.to_i
      return mode if [1, 2].include?(mode)

      @display.try_again
    end
  end

  def difficulty
    loop do
      diff = gets.chomp.to_i
      return diff if (1..3).include?(diff)

      @display.try_again
    end
  end

  # Play as code maker
  def mode_maker
    @p = Player.new('Player', is_maker: true)
    @c = ComputerPlayer.new('Computer')

    while @board.current_turn < MAX_TURNS[@difficulty - 1]
      @display.print_board(@board)
      guess = @c.guess(@board)
      @board.update(guess, @p.code)
      sleep(1)
      next unless guess == @p.code

      @display.print_board(@board)
      @display.breaker_win(@c, @p.code)
      return
    end

    @display.print_board(@board)
    @display.maker_win(@p, @c)
  end

  # Play as code breaker
  # (mode_maker and mode_breaker could be merged with a bit of work, but I opted not to)
  def mode_breaker
    @p = Player.new('Player')
    @c = ComputerPlayer.new('Computer', is_maker: true)

    while @board.current_turn < MAX_TURNS[@difficulty - 1]
      # p @c.code
      @display.print_board(@board)
      guess = @p.guess
      @board.update(guess, @c.code)
      next unless guess == @c.code

      @display.print_board(@board)
      @display.breaker_win(@p, @c.code)
      return
    end

    @display.print_board(@board)
    @display.maker_win(@c, @p)
  end
end
