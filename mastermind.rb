class Board
  CODE_SYMBOLS = ('1'..'6').to_a
  CODE_LENGTH = 4
  MAX_TURNS = 12
  CLUE_WEAK = '~'.freeze
  CLUE_STRONG = 'X'.freeze

  attr_reader :board

  def initialize
    @board = Array.new(MAX_TURNS) { Array.new(CODE_LENGTH, '_') }
    @current_turn = 0
  end
end

class Player
  attr_reader :name, :code

  # Code should be nil if player is not a code maker
  def initialize(name, code = nil)
    @name = name
    @code = code
  end
end

class ComputerPlayer < Player
  def initialize(name)
    super
    @code = generate_code
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

class Display
  def intro
    puts "Welcome to Mastermind!\n\n"
    rules
    selection
  end

  def print_board(board)
    board.board.each do |row|
      row.each do |cell|
        print "| #{cell} "
      end
      print "|\n"
    end
  end

  private

  def rules
    puts 'Rules:'
    puts '1. There is a code MAKER and a code BREAKER.'
    puts "2. The code maker comes up with a secret #{Board::CODE_LENGTH}-digit code,"
    puts "   made from the symbols #{Board::CODE_SYMBOLS.first} to #{Board::CODE_SYMBOLS.last}."
    puts "3. The code breaker has #{Board::MAX_TURNS} attempts to break the code."
    puts '4. If the code breaker gets 1 correct symbol in the correct location,'
    puts "   they receive this clue: #{Board::CLUE_STRONG}"
    puts '5. If the code breaker gets 1 correct symbol in the wrong location,'
    puts "   they receive this clue: #{Board::CLUE_WEAK}\n\n"
  end

  def selection
    puts 'Please make a selection:'
    puts '1 - Be the code MAKER'
    puts '2 - Be the code BREAKER'
  end
end

class Game
  def initialize
    @board = Board.new
    @display = Display.new
  end

  def start
    @display.intro
    while true
      mode = gets.chomp.to_i
      break if [1, 2].include?(mode)

      puts 'Oops, try again:'
    end

    mode_maker if mode == 1
    mode_breaker if mode == 2
  end

  private

  # Play as code maker
  def mode_maker
    # TODO
  end

  # Play as code breaker
  def mode_breaker
    @p = Player.new('Player')
    @c = ComputerPlayer.new('Computer')

    @display.print_board(@board)
  end
end

g = Game.new
g.start
