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

class Participant
  attr_reader :name

  def initialize
    @hand = []
    @name = nil
  end

  def busted?
    hand_total > 21
  end

  def add_to_hand(card)
    @hand << card
  end

  def hand_total
    num_aces = 0
    total = 0
    @hand.each do |card|
      num_aces += 1 if card.rank == 'A'
      total += card.value
    end
    num_aces.times do
      total -= 10 if total > 21
    end
    total
  end

  def display_hand
    puts "#{name} has #{join_or(@hand, ', ', 'and')}"
  end
end

class Dealer < Participant
  def initialize
    super
    @name = "The dealer"
  end

  def display_hand_with_hidden_card
    puts "#{name} has #{@hand.first} and a hidden card."
  end
end

class Player < Participant
  def prompt_for_name
    puts "What is your name? "
    name = nil
    loop do
      name = gets.chomp
      break unless name.empty?
      puts "Name cannot be empty, try again."
    end
    @name = name
  end

  def initialize
    super
    prompt_for_name
  end
end

class Deck
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        @cards << Card.new(suit, rank)
      end
    end
    shuffle_cards
  end

  def shuffle_cards
    shuffled_deck = []
    until @cards.empty?
      card_to_add = @cards.sample
      shuffled_deck << card_to_add
      @cards.delete(card_to_add)
    end
    @cards = shuffled_deck
  end

  def deal(recipient: nil, num_cards: 1, verbose: false)
    num_cards.times do
      new_card = @cards.pop
      puts "#{recipient.name} draws a #{new_card}" if verbose
      recipient.add_to_hand(new_card)
    end
  end
end

class Card
  SUITS = %w(♣ ♦ ♥ ♠)
  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def value
    if @rank.to_i != 0
      @rank.to_i
    elsif @rank == 'A'
      11
    else
      10
    end
  end

  def to_s
    @rank + @suit
  end
end

class TwentyOneGame
  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def player_choice
    puts "Would you like to hit (h) or stay (s)?"
    response = nil
    loop do
      response = gets.chomp.downcase
      return response if %w(h s).include?(response)
      puts "Invalid response, try again."
    end
  end

  def show_hands
    player.display_hand
    dealer.display_hand_with_hidden_card
  end

  def player_hits
    puts "#{player.name} hits"
    deck.deal(recipient: player, verbose: true)
  end

  def player_turn
    show_hands
    loop do
      response = player_choice
      case response
      when 'h' then player_hits
      when 's'
        puts "#{player.name} stays."
        break
      end
      player.display_hand
      break if player.busted?
    end
  end

  def compare_scores
    puts "#{player.name} has a total of #{player.hand_total}\n" \
         "#{dealer.name} has a total of #{dealer.hand_total}"
    case player.hand_total <=> dealer.hand_total
    when -1 then puts "#{player.name} loses."
    when 0  then puts "It's a draw"
    when 1  then puts "#{player.name} wins!"
    end
  end

  def determine_winner
    if player.busted?
      puts "#{player.name} busted.\n#{dealer.name} wins!"
    elsif dealer.busted?
      puts "#{dealer.name} busted.\n#{player.name} wins!"
    else
      compare_scores
    end
  end

  def dealer_turn
    dealer.display_hand
    while dealer.hand_total < 17
      deck.deal(recipient: dealer, verbose: true)
      return if dealer.busted?
    end
    puts "#{dealer.name} stays"
  end

  def deal_cards
    deck.deal(recipient: player, num_cards: 2)
    deck.deal(recipient: dealer, num_cards: 2)
  end

  def play
    deal_cards
    player_turn
    dealer_turn unless player.busted?
    determine_winner
  end
end

TwentyOneGame.new.play
