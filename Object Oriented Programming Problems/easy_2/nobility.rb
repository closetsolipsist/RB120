module Walker
  def walk
    puts "#{self.name} #{self.gait} forward"
  end
end

class Person
  include Walker
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  include Walker
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Walker
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end

class Noble
  include Walker

  attr_reader :name, :title

  def initialize(name, title)
    @name = name
    @title = title
  end

  def walk
    print title + ' '
    super
  end

  private

  def gait
    "struts"
  end
end

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"

byron = Noble.new("Byron", "Lord")
byron.walk