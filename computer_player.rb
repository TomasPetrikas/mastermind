# frozen_string_literal: true

require_relative 'player'
require_relative 'board'

# Computer player
class ComputerPlayer < Player
  def initialize(name, is_maker: false)
    super
  end

  def guess(board)
    # Return a random guess on first turn
    if board.current_turn.zero?
      @codes = generate_all_codes
      return generate_code
    end

    previous_guess = board.board[board.current_turn - 1].clone
    previous_clues = board.clues[board.current_turn - 1].clone
    @codes.delete(previous_guess)

    @codes.each_with_index do |c, i|
      @codes[i] = nil unless board.generate_clues(c.clone, previous_guess.clone) == previous_clues
    end

    @codes.delete(nil)

    guess = @codes.sample.join
    raise "Error: guess '#{guess}' invalid" unless Board.valid?(guess)

    guess
  end

  private

  def generate_code
    code = []
    Board::CODE_LENGTH.times do
      code << Board::CODE_SYMBOLS.sample
    end

    code.join
  end

  def generate_all_codes
    Board::CODE_SYMBOLS.repeated_permutation(Board::CODE_LENGTH).to_a
  end
end
