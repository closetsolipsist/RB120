class MiniLangError < StandardError; end
class DivideByZeroError < MiniLangError; end
class EmptyStackError < MiniLangError; end
class InvalidTokenError < MiniLangError; end

class Minilang
  attr_accessor :register, :stack
  def initialize(operations)
    puts "---------------"
    @register = 0
    @stack = []
    @operations = operations.split
  end
  def eval
    @operations.each do |operation|
      puts "Stack: #{stack}"
      puts "Register: #{register}"
      puts "Operation: #{operation}"
      if operation.to_i.to_s == operation
        @register = operation.to_i
      else
        begin
          self.send(operation.downcase)
        rescue NoMethodError
          raise InvalidTokenError
        end
      end
    end
  end
  def push
    stack << register
  end
  def add
    check_for_empty
    @register += stack.pop
  end
  def sub
    check_for_empty
    @register -= stack.pop
  end
  def mult
    check_for_empty
    @register *= stack.pop
  end
  def div
    check_for_empty
    value = stack.pop
    unless value == 0
      @register /= value
    else
      raise DivideByZeroError
    end
  end
  def mod
    check_for_empty
    value = stack.pop
    unless value == 0
      @register %= value
    else
      raise DivideByZeroError
    end
  end
  def pop
    check_for_empty
    @register = stack.pop
  end
  def print
    puts register
  end
  def check_for_empty
    if stack.empty?
      raise EmptyStackError
    end
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)