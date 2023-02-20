class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new

p [Cat, Animal, Object, Kernel, BasicObject]

cat1.color