class Pet
  def initialize(animal_type, name)
    @animal_type = animal_type
    @name = name
  end

  def to_s
    "a #{@animal_type} named #{@name}"
  end
end

class Owner
  attr_reader :name
  attr_accessor :number_of_pets
  def initialize(n)
    @name = n
    @number_of_pets = 0
  end
end

class Shelter

  def initialize
    @adoptions = Hash.new([])
    @unadopted_pets = []
  end

  def add_new_unadopted_pets(pets)

    pets.each do |pet|
      @unadopted_pets << pet
    end
  end

  def adopt(owner, pet)
    if @unadopted_pets.include?(pet)
      @unadopted_pets.delete(pet)
      @adoptions[owner] += [pet]
      owner.number_of_pets += 1
    else
      puts "Error: pet not up for adoption"
    end
  end

  def print_adoptions
    @adoptions.each do |owner, pets|
      puts "#{owner.name} has adopted the following pets:"
      pets.each { |pet| puts pet }
      puts
    end
  end

  def print_unadopted_pets
    puts "The animal shelter has the following unadopted pets:"
    @unadopted_pets.each do |pet|
      puts pet
    end
    puts
  end

  def number_of_unadopted_pets
    @unadopted_pets.size
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell     = Pet.new('parakeet', 'Bluebell')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new

pets = [butterscotch, pudding, darwin, kennedy,
        sweetie, molly, chester, asta, laddie,
        fluffy, kat, ben, chatterbox, bluebell]

shelter.add_new_unadopted_pets(pets)

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_unadopted_pets
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal shelter has #{shelter.number_of_unadopted_pets} adopted pets."