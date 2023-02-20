class CircularQueue
  def initialize(size)
    @slots = [nil] * size
    @size = size
    @current_position = 0
  end

  def enqueue(element)
    @slots[@current_position] = element
    @current_position += 1
    @current_position %= @size
  end

  def dequeue
    return nil if @slots.all?(&:nil?)
    index = @current_position
    while @slots[index] == nil
      index += 1
      index %= @size
    end
    value = @slots[index]
    @slots[index] = nil
    return value
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil