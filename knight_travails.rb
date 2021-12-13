class Queue
  def initialize(array = [])
    @queue = array
  end

  def enqueue(element)
    if element.is_a?(Array)
      @queue += element
    else
      @queue << element
    end
  end

  def dequeue
    @queue.shift
  end

  def empty?
    @queue.empty?
  end
end

def on_chessboard
  proc { |(x, y)| x >= 0 && x <= 7 && y >= 0 && y <= 7 }
end

def optimal_moves(source, destination)
  return [destination] if source == destination

  queue = Queue.new(possible_moves([destination]))

  until queue.empty?
    move_set = queue.dequeue
    return move_set if move_set[0] == source

    queue.enqueue(possible_moves(move_set))
  end
end

def possible_moves(move_set)
  current_position = move_set[0]

  possible_next = [
    [1, 2], [2, 1], [-1, -2], [-2, -1], [1, -2], [2, -1], [-1, 2], [-2, 1]
  ].map do |difference|
    [current_position[0] + difference[0], current_position[1] + difference[1]]
  end.filter(&on_chessboard)  # don't allow knight to leave chessboard

  possible_next.map { |next_move| move_set.clone.unshift(next_move) }
end

def knight_moves(source, destination)
  unless [destination, source].all?(&on_chessboard)
    puts 'Invalid source/destination supplied!'
    return
  end

  move_set = optimal_moves(source, destination)

  puts "You made it in #{move_set.length - 1} moves! Here's your path:"
  move_set.each { |move| p move }
end
