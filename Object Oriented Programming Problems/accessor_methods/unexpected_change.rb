class Person
  def name
    [@first_name, @last_name].join(' ')
  end
  def name=(name)
    @first_name, @last_name = name.split
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name