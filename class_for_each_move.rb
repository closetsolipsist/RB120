def sample_from_distribution(outcomes, probabilities)
  puts "Error, invalid distribution" if (probabilities.sum - 1.0) > 1e-6
  uniform_0_1 = rand
  current_sum = 0.0
  index = 0
  loop do
    current_sum += probabilities[index]
    break if current_sum > uniform_0_1
    index += 1
  end
  outcomes[index]
end

class Move
  attr_reader :value

  def >(other_move)
    other_move < self
  end

  def to_s
    self.class.to_s.downcase
  end

  def ==(other_move)
    self.class == other_move.class
  end

  def self.get_move(move_name)
    case move_name
    when "rock"
      Rock.new
    when "paper"
      Paper.new
    when "scissors"
      Scissors.new
    end
  end
end

class Rock < Move
  def <(other_move)
    other_move.class == Paper
  end
end

class Paper < Move
  def <(other_move)
    other_move.class == Scissors
  end
end

class Scissors < Move
  def <(other_move)
    other_move.class == Rock
  end
end

class Player
  attr_accessor :move, :name, :score, :moves

  def initialize
    set_name
    self.score = 0
    self.moves = []
  end

  def show_moves
    puts '-' * 20 + "\n#{name}'s moves:\n" + '-' * 20
    moves.each_with_index do |move, index|
      puts "#{index + 1}: #{move}"
    end
  end
end

class Human < Player
  def set_name
    puts "What is your name?"
    n = nil
    loop do
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if ['rock', 'paper', 'scissors'].include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.get_move(choice)
    self.moves << move
  end
end
class Computer < Player
  STRATEGIES = {'R2D2' => {rock: 1,   paper: 0, scissors: 0},
                'Hal' => {rock: 0.8, paper: 0, scissors: 0.2},
                'CHAPPiE' => {rock: 0.2, paper: 0.2, scissors: 0.6}}
  def set_name
    characters = STRATEGIES.keys
    self.name = characters.sample
  end

  def choose
    outcomes = STRATEGIES[name].keys.map(&:to_s)
    probabilities = STRATEGIES[name].values
    self.move = Move.get_move(sample_from_distribution(outcomes, probabilities))
    self.moves << move
  end
end

class RPSGame
  attr_accessor :human, :computer, :winner

  def initialize(human, computer)
    @human = human
    @computer = computer
    @winner = nil
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def determine_winner
    if human.move > computer.move
      @winner = human
    elsif human.move < computer.move
      @winner = computer
    end
  end

  def display_winner
    if @winner
      puts "#{@winner.name} won!"
    else
      puts "It's a tie"
    end 
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, must be y or n."
    end
    answer == 'y'
  end

  def play
    human.choose
    computer.choose
    display_moves
    determine_winner
    display_winner
  end
end

class RPSMatch
  def initialize(points_to_win)
    @points_to_win = points_to_win
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors"
    puts "Your AI opponent is...#{@computer.name}!!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def play
    display_welcome_message
    while [@human.score, @computer.score].max < @points_to_win
      game = RPSGame.new(@human, @computer)
      game.play
      winner = game.winner
      winner.score += 1 if winner
      announce_score
    end
    display_goodbye_message
    @human.show_moves
    @computer.show_moves
  end

  def announce_score
    puts "Current score: #{@human.name}: #{@human.score}, #{@computer.name}: #{@computer.score}"
  end
end

RPSMatch.new(3).play