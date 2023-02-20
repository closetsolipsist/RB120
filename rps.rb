class Player
  def initialize
    @is_computer = false
  end

  def choose
    if @is_computer
      @choice = Move.random
      puts "The computer chose #{@choice}"
    else
      puts "Would you like rock, paper, or scissors?"
      @choice = Move.from_input
    end
  end
end

class Move
  MOVE_NAMES = %w(rock paper scissors)
  def initialize(move_type)
    @move_type = move_type
  end
  
  def random
    Move(MOVE_NAMES.sample)
  end

  def from_input
    loop do
      choice = gets.chomp
      break if MOVE_NAMES.include?(choice)
      puts "Invalid choice, try again"
    end
    Move(choice)
  end
  
  def to_s
    @move_type
  end
end

class Rule
  def initialize
  end
end

class RPSGame
  attr_accessor :human, :computer
  def initialize
    @human = Player.new
    @computer = Player.new
  end
  def display_welcome_message
    puts "Welcome to RPS!"
  end

  def display_goodbye_message
    puts "Bye!"
  end

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_winner
    display_goodbye_message
  end
end

def compare(move1, move2)