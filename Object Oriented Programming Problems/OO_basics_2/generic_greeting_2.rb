class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.generic_greeting
    puts "The abstract concept of a cat says hello!"
  end

  def personal_greeting
    puts "#{name} says hello!"
  end
  
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting