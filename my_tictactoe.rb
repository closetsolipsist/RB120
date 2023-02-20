=begin
Players alternate placing symbols on a 3x3 board; one player places X and the other O. A player wins if they
have three of their symbol in a row. If the board is filled without anyone winning, it's a draw.

player
  - wins
  - chooses move
board
  - is full
  - has three in a row
  - has move played on it
=end

class Board
  def initialize
    @squares = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
  end

  def empty_squares
    [0, 1, 2].product([0, 1, 2]).select { |row, col| @squares[row][col] == ' ' }
  end

  def to_s
    (@squares.map { |row| row.join }).join('\n')
  end

  def place_move(position, symbol)
    row, col = *position
    @squares[row][col] = symbol
  end
end

class Game
  attr_reader :winner

  def initialize(players)
    @players = players
    @current_player = players.sample
    @winner = nil
  end

  def swap_current_player
    @current_player = @players.find { |player| player != @current_player }
  end

  def show_draw_message
    puts "It was a draw"
  end

  def show_win_message
    puts "#{@winner} won!"
  end

  def play
    loop do
      puts board
      board.place_move(current_player.choose_move, current_player.symbol)
      if @current_player.has_won(board)
        @winner = @current_player
        show_win_message
      elsif board.full
        show_draw_message
      end
      swap_current_player
    end
  end
end

class Player
  attr_reader :symbol
end

class Human < Player
  def initialize
    @symbol = 'X'
  end

  def choose_move(board)
    puts board.empty_squares
    row = gets.chomp.to_i
    col = gets.chomp.to_i
    [row, col]
  end
end

class Computer < Player
  def initialize
    @symbol = 'O'
  end

  def choose_move(board)
    board.empty_squares.sample
  end
end



players = [Human.new, Computer.new]
Game.new.play(players)