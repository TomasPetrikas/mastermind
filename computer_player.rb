# frozen_string_literal: true

require_relative 'player'
require_relative 'board'

# Computer player
class ComputerPlayer < Player
  def initialize(name, is_maker: false)
    super
  end

  # TODO: make this actually good
  def guess(_board)
    generate_code
  end

  private

  def generate_code
    code = []
    Board::CODE_LENGTH.times do
      code << Board::CODE_SYMBOLS.sample
    end

    code.join
  end
end
