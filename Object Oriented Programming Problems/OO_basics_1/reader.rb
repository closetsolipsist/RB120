class Cat
  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def greet
    puts "Hello, I'm #{name}!"
  end
end

kitty = Cat.new("Sophie")
kitty.greet