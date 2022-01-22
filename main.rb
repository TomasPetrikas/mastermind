# frozen_string_literal: true

require_relative 'board'
require_relative 'display'
require_relative 'player'
require_relative 'computer_player'
require_relative 'game'

def play_game
  g = Game.new
  g.start
  repeat_game
end

def repeat_game
  puts "Would you like to play again? Enter 'y' for yes or 'n' for no: "
  gets.chomp.downcase == 'y' ? play_game : return
end

play_game
