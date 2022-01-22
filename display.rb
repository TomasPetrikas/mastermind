# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'computer_player'

# Deals with (most of) the screen output
class Display
  def intro
    puts "Welcome to Mastermind!\n\n"
    rules
    selection
  end

  def try_again
    puts 'Oops, try again:'
  end

  def clear_screen
    Gem.win_platform? ? (system 'cls') : (system 'clear')
  end

  def print_board(board)
    clear_screen

    board.board.each_with_index do |row, row_index|
      row.each do |cell|
        print "| #{cell} "
      end
      print "| #{board.clues[row_index].join}\n"
    end
  end

  def breaker_win(player, secret_code)
    puts "#{player.name} has guessed correctly! The code was #{secret_code}."
  end

  def maker_win(winning_player, losing_player)
    puts "#{losing_player.name} has run out of guesses. #{winning_player.name} wins!"
    puts "(The code was #{winning_player.code})"
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
