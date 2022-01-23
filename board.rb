# frozen_string_literal: true

# Stores and updates the game state
class Board
  CODE_SYMBOLS = ('1'..'6').to_a
  CODE_LENGTH = 4
  CLUE_WEAK = '~'
  CLUE_STRONG = 'X'

  attr_reader :board, :clues, :current_turn

  def initialize(max_turns = 12)
    @board = Array.new(max_turns) { Array.new(CODE_LENGTH, '_') }
    @clues = Array.new(max_turns) { Array.new(CODE_LENGTH, ' ') }
    @current_turn = 0
  end

  def update(guess_code, secret_code)
    unless Board.valid?(guess_code) && Board.valid?(secret_code)
      raise "Error: one of the following codes is incorrect. Guess: #{guess_code}, Secret: #{secret_code}"
    end

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
