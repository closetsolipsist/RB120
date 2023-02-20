class GuessingGame
  NUMBER_OF_GUESSES = 7
  HIGHEST_NUMBER = 100

  def initialize
    reset
  end

  def reset
    @guesses_remaining = NUMBER_OF_GUESSES
    @secret_number = (1..HIGHEST_NUMBER).to_a.sample
  end

  def play
    reset
    while @guesses_remaining > 0
      puts "You have #{@guesses_remaining} guesses remaining."
      guess = get_guess
      case guess <=> @secret_number
      when -1 then puts "Your guess is too low."
      when 1  then puts "Your guess is too high."
      when 0
        puts "That's the number!"
        break
      end
      @guesses_remaining -= 1
    end
    puts
    if @guesses_remaining == 0
      puts "You have no more guesses. You lost!"
    else
      puts "You won!"
    end
  end

  def get_guess
    guess = nil
    loop do
      print "Enter a number between 1 and #{HIGHEST_NUMBER}: "
      guess = gets.chomp.to_i
      break if 1 <= guess && guess <= HIGHEST_NUMBER
      print "Invalid guess. "
    end
    guess
  end
end

game = GuessingGame.new
game.play
game.play