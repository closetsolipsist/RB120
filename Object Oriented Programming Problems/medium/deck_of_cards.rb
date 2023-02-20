class Card
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    RANKS.index(@rank) <=> RANKS.index(other.rank)
  end

  def ==(other)
    rank == other.rank && suit == other.suit
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  def initialize
    reset
  end

  def reset
    @cards = []
    RANKS.product(SUITS) { |rank, suit| @cards << Card.new(rank, suit) }
    @cards.shuffle!
  end
  
  def draw
    unless @cards.empty?
      @cards.pop
    else
      reset
      @cards.pop
    end
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.