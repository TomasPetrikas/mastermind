# frozen_string_literal: true

# Code probably could've been its own class, but I was too lazy to refactor

require_relative 'board'

# Human player
class Player
  attr_reader :name, :code

  def initialize(name, is_maker: false)
    @name = name
    @code = generate_code if is_maker
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

  private

  def generate_code
    while true
      print "#{@name}, enter your secret code: "
      code = gets.chomp
      puts ''
      break if Board.valid?(code)
    end

    code
  end
end
