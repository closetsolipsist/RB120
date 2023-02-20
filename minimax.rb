require 'pry'
=begin
Generic minimax for game of alternating moves:

state object
possible_moves




M                   o
                   /\
Y                 o  o
                 /\  /\
M              [W] o W O
                  /\
Y                W O       
Recursively: if it's your turn and you have just reached a losing state, your move is losing
             if it's your turn and all of your moves go to a winning move, you are losing

if it's my turn and I have just reached a winning state, I'm winning
if one of my moves gives a losing state, I'm winning

move object contains move and array of succeeding states

a GameTree object contains the following things: the current player
                                                 a dictionary with keys moves and value the resulting game trees
                                                 whether the position is winning
=end

class State
  attr_reader :state, :current_player
  def initialize(state: nil, current_player: nil)
    @state = state
    @current_player = current_player
  end
  
  def standardize
    state
  end

  def self.other_player(current_player)
    [:me, :you].find { |player| player != current_player }
  end
end


class NimState < State
  def possible_moves
    moves = []
    state.each_with_index do |pile, index|
      (1..pile).each do |num_to_take|
        moves << [index, num_to_take]
      end
    end
    moves
  end

  def apply_move(move)
    index, num_to_take = *move
    new_player = State.other_player(current_player)
    NimState.new(state: @state[0...index] + [@state[index] - num_to_take] + @state[index + 1..], \
                 current_player: new_player)
  end

  def to_s
    state.to_s
  end

  def win?
    @state.all? { |pile_size| pile_size == 0 }
  end

  def standardize
    [state.sort, current_player]
  end
end

class TTTState < State
  WINNING_LINES = [ [[0, 0], [0, 1], [0, 2]],
                    [[1, 0], [1, 1], [1, 2]],
                    [[2, 0], [2, 1], [2, 2]],
                    [[0, 0], [1, 0], [2, 0]],
                    [[0, 1], [1, 1], [2, 1]],
                    [[0, 2], [1, 2], [2, 2]],
                    [[0, 0], [1, 1], [2, 2]],
                    [[0, 2], [1, 1], [2, 0]] ]

  SYMBOLS = {me: 'X', you: 'O'}

  def possible_moves
    empty_squares = [0, 1, 2].product([0, 1, 2]).select{ |row, col| state[row][col] == ' ' }
    symbol = SYMBOLS[current_player]
    empty_squares.map { |square| [square, symbol] }
  end

  def apply_move(move)
    new_player = State.other_player(current_player)
    updated_state = state.map(&:clone)
    row, column = *move.first
    symbol = move[1]
    updated_state[row][column] = symbol
    state_after_move = TTTState.new(state: updated_state, current_player: new_player)
  end

  def to_s
    state.map {|row| row.join(' ')}.join("\n") + "\n" + '-' * 10
  end

  def win?
    WINNING_LINES.any? do |line|
      squares_on_line = line.map { |row, column| state[row][column] }
      squares_on_line.all? { |square| square == SYMBOLS[:me] }
    end
  end

  def leads_to_win?(state, winning_player)
    losing_player = State.other_player(winning_player)
    player = state.current_player
    all_continuations = {}
    if all_continuations.key?(state.standardize)
      return all_continuations[state.standardize]
    end
    continuations = []
    state.possible_moves.each do |move|
      continuations << state.apply_move(move)
    end
    if player == winning_player
      continuations.any? do |continuation|
        leads_to_win?(continuation)
      end
    elsif player == :you
      return true if state.win?
      continuations.all? do |continuation|
        leads_to_win?(continuation)
      end
    end
  end
  
end

=begin
class GameTree
  @@all_continuations = {}
  attr_reader :state, :player
  def initialize(state)
    @state = state
    @player = state.current_player
    @continuations = continuations
    @leads_to_win = leads_to_win?
    @@all_continuations[state.standardize] = leads_to_win?
  end
  
  def continuations
    continuations = []
    state.possible_moves.each do |move|
      continuations << GameTree.new(state.apply_move(move))
    end
    continuations
  end

  def leads_to_win?
    if @@all_continuations.key?(state.standardize)
      return @@all_continuations[state.standardize]
    end
    if player == :me
      continuations.any? do |tree|
        tree.leads_to_win?
      end
    elsif player == :you
      return true if state.win?
      continuations.all? do |tree|
        tree.leads_to_win?
      end
    end
  end

  def to_s
    state.to_s
  end
end
=end

initial_board = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
state = TTTState.new(state: initial_board, current_player: :me)

loop do
  winning_moves = state.possible_moves.select do |move|
    leads_to_win?(state.apply_move(move))
  end
  if winning_moves
    move = winning_moves.first
  else
    move = state.possible_moves.sample
  end
  state = state.apply_move(move)
  puts state
  break if state.win?
end

p leads_to_win?(initial_state)
