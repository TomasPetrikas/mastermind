# frozen_string_literal: true

require_relative 'board'
require_relative 'display'
require_relative 'player'
require_relative 'computer_player'

# Controller for the actual game
class Game
  def initialize
    @board = Board.new
    @display = Display.new
  end

  def start
    @display.clear_screen
    @display.intro
    while true
      mode = gets.chomp.to_i
      break if [1, 2].include?(mode)

      @display.try_again
    end

    mode_maker if mode == 1
    mode_breaker if mode == 2
  end

  private

  # Play as code maker
  def mode_maker
    @p = Player.new('Player', is_maker: true)
    @c = ComputerPlayer.new('Computer')

    Board::MAX_TURNS.times do
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
  def mode_breaker
    @p = Player.new('Player')
    @c = ComputerPlayer.new('Computer', is_maker: true)

    Board::MAX_TURNS.times do
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
