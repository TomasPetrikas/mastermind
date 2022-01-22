# Code probably should've been its own class, but I was too lazy to refactor

class Board
  CODE_SYMBOLS = ('1'..'6').to_a
  CODE_LENGTH = 4
  MAX_TURNS = 12
  CLUE_WEAK = '~'.freeze
  CLUE_STRONG = 'X'.freeze

  attr_reader :board, :clues, :current_turn

  def initialize
    @board = Array.new(MAX_TURNS) { Array.new(CODE_LENGTH, '_') }
    @clues = Array.new(MAX_TURNS) { Array.new(CODE_LENGTH, ' ') }
    @current_turn = 0
  end

  def update(guess_code, secret_code)
    return unless Board.valid?(guess_code) && Board.valid?(secret_code)

    guess_arr = guess_code.split('')
    secret_arr = secret_code.split('')
    @board[@current_turn] = guess_arr.clone
    @clues[@current_turn] = generate_clues(guess_arr, secret_arr)

    @current_turn += 1
  end

  def self.valid?(code)
    return false if code.length != CODE_LENGTH

    code.split('').each do |char|
      return false unless CODE_SYMBOLS.include?(char)
    end

    true
  end

  private

  # Receives two arrays of length CODE_LENGTH
  # Returns an array of length CODE_LENGTH
  def generate_clues(guess_symbols, secret_symbols)
    clues = []

    # p secret_symbols.join

    CODE_LENGTH.times do |i|
      next unless secret_symbols[i] == guess_symbols[i]

      clues << CLUE_STRONG
      guess_symbols[i] = nil
      secret_symbols[i] = nil
    end

    guess_symbols.delete(nil)
    secret_symbols.delete(nil)

    # p guess_symbols
    # p secret_symbols

    secret_symbols.each_with_index do |_ss, i|
      guess_symbols.each_with_index do |_gs, j|
        next unless secret_symbols[i] == guess_symbols[j]
        next if secret_symbols[i].nil?

        clues << CLUE_WEAK
        guess_symbols[j] = nil
        secret_symbols[i] = nil
      end
    end

    # guess_symbols.delete(nil)
    # secret_symbols.delete(nil)

    # p guess_symbols
    # p secret_symbols

    clues << ' ' while clues.length < CODE_LENGTH

    clues
  end
end

class Player
  attr_reader :name, :code

  # Code should be nil if player is not a code maker
  def initialize(name, code = nil)
    @name = name
    @code = code
  end

  def guess
    while true
      print "#{@name}, enter your guess: "
      guess = gets.chomp
      puts ''
      break if Board.valid?(guess)
    end

    guess
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

  def try_again
    puts 'Oops, try again:'
  end

  def print_board(board)
    board.board.each_with_index do |row, row_index|
      row.each do |cell|
        print "| #{cell} "
      end
      print "| #{board.clues[row_index].join}\n"
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

      @display.try_again
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

    Board::MAX_TURNS.times do
      @display.print_board(@board)
      guess = @p.guess
      @board.update(guess, @c.code)
    end
  end
end

g = Game.new
g.start
