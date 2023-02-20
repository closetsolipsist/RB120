class GuessingGame

  def initialize(low, high)
    @low = low
    @high = high
    reset
  end

  def reset
    @guesses_remaining = Math.log2(@high - @low + 1).to_i + 1
    @secret_number = (@low..@high).to_a.sample
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
      print "Enter a number between #{@low} and #{@high}: "
      guess = gets.chomp.to_i
      break if @low <= guess && guess <= @high
      print "Invalid guess. "
    end
    guess
  end
end

game = GuessingGame.new(501, 1500)
game.play
