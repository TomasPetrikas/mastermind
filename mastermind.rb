class Board
  CODE_SYMBOLS = ('1'..'6').to_a
  CODE_LENGTH = 4
  MAX_TURNS = 12
  CLUE_WEAK = '~'.freeze
  CLUE_STRONG = 'X'.freeze

  attr_reader :board

  def initialize()
    @board = Array.new(MAX_TURNS) { Array.new(CODE_LENGTH, '_') }
  end
end

class Display
  def intro
    puts "Welcome to Mastermind!\n\n"
    rules
    selection
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
      @mode = gets.chomp.to_i
      break if [1, 2].include?(@mode)

      puts 'Oops, try again:'
    end

  end
end

g = Game.new
g.start
