require 'pry'

def clear
  system 'clear'
end

def prompt_to_continue
  puts "Press enter to continue..."
  gets
  clear
end

def join_or(arr, separator = ', ', final_separator = 'or')
  arr_strs = arr.map(&:to_s)
  if arr.size == 1
    arr_strs[0]
  elsif arr.size == 2
    arr_strs[0] + " #{final_separator} " + arr_strs[1]
  else
    arr_strs[-1] = "#{final_separator} #{arr_strs[-1]}"
    arr_strs.join(separator)
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals
  CENTER_SQUARE_KEY = 5

  def initialize
    @squares = {}
    reset
  end

  def center_square
    @squares[5]
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def winning_moves(marker)
    winning_moves = []
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if squares.count { |square| square.marker == marker } == 2 &&
        squares.count { |square| square.marker == ' ' } == 1
        winning_square = line.find { |index| @squares[index].marker == ' ' }
        winning_moves << winning_square
      end
    end
    winning_moves
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :score, :name
  attr_accessor :marker

  def initialize(marker: nil)
    @marker = marker
    @name = nil
    @score = 0
  end

  def reset_score
    @score = 0
  end

  def increment_score!
    @score += 1
  end
end

class HumanPlayer < Player
  def assign_name
    puts "What is your name? "
    response = nil
    loop do
      response = gets.chomp
      break unless response.empty?
      puts "Name cannot be empty, try again."
    end
    @name = response
  end
end

class ComputerPlayer < Player
  def assign_name
    @name = ["Einstein", "Holmes", "Darwin", "Archimedes", "Aristotle"].sample
  end
end

class TTTGame
  MARKERS = %w(X O)

  attr_reader :board, :human, :computer, :winner

  def initialize(human, computer)
    @board = Board.new
    @human = human
    @computer = computer
    @current_marker = nil
    @winner = nil
    @starting_player = nil
  end

  def determine_starting_player
    puts "Who would you like to go first? (m: me, c: computer, r: random)?"
    choice = nil
    loop do
      choice = gets.chomp.downcase
      break if %w(m c r).include?(choice)
      puts "Invalid option, try again."
    end
    case choice
    when 'm'
      @current_marker = human.marker
    when 'c'
      @current_marker = computer.marker
    when 'r'
      @current_marker = [human.marker, computer.marker].sample
      puts "You are going first" if @current_marker == human.marker
      puts "The computer is going first" if @current_marker == computer.marker
      prompt_to_continue
    end
  end

  def determine_markers
    puts "Which marker would you like, X or O?"
    marker_choice = nil
    loop do
      marker_choice = gets.chomp.upcase
      break if %w(X O).include?(marker_choice)
    end
    human.marker = marker_choice
    computer.marker = MARKERS.find { |marker| marker != human.marker }
  end

  def play
    determine_starting_player
    determine_markers
    display_board
    players_move
    determine_winner
    display_result
  end

  private

  def players_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  def display_board
    puts "You're #{human.marker}. Computer is #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def human_moves
    puts "Choose a square (#{join_or(board.unmarked_keys, ', ', 'or')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    moves_to_draw_from = []
    if !board.winning_moves(computer.marker).empty?
      moves_to_draw_from = board.winning_moves(computer.marker)
    elsif !board.winning_moves(human.marker).empty?
      moves_to_draw_from = board.winning_moves(human.marker)
    elsif board.center_square.marker == ' '
      moves_to_draw_from = [Board::CENTER_SQUARE_KEY]
    else
      moves_to_draw_from = board.unmarked_keys
    end
    board[moves_to_draw_from.sample] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def determine_winner
    case board.winning_marker
    when human.marker
      @winner = human
    when computer.marker
      @winner = computer
    else
      @winner = nil
    end
  end

  def display_result
    clear_screen_and_display_board

    case winner
    when human
      puts "You won!"
    when computer
      puts "Computer won!"
    when nil
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

class TTTMatch

  attr_reader :human, :computer
  POINTS_TO_WIN = 5

  def initialize
    @human = HumanPlayer.new(marker: 'X')
    @computer = ComputerPlayer.new(marker: 'O')
    @human.assign_name
    @computer.assign_name
  end

  def display_scores
    puts "Score:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    prompt_to_continue
  end

  def display_welcome_message
    clear
    puts "Welcome to Tic Tac Toe, #{human.name}! Your AI opponent is #{computer.name}!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def announce_winner
    if human.score >= POINTS_TO_WIN
      puts "You won the match!"
    elsif computer.score >= POINTS_TO_WIN
      puts "The computer won the match."
    end
  end

  def play
    clear
    display_welcome_message
    while [human.score, computer.score].max < 5
      game = TTTGame.new(human, computer)
      game.play
      game.winner.increment_score! if game.winner
      display_scores
    end
    announce_winner
    display_goodbye_message
  end
end

TTTMatch.new.play