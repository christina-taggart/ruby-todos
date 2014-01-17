require 'csv'

Task = Struct.new(:task, :done) #Task encapsulates state only

class ListView
  def initialize(to_be_viewed)
    @to_be_viewed = to_be_viewed
    print
  end

  def print
    puts "\nThings to do:\n\n"
    @to_be_viewed.each_with_index { |task, index| puts "#{(index+1).to_s.rjust(2)}.   #{task.done ? '[X]' : '[ ]'}   #{task.task}" }
  end
end

class ListController
  def initialize(user_input = ARGV)
    execute
  end

  def execute
    route_to_model
    route_to_view
  end

  def route_to_model
    @response = Model.new(ARGV.first, ARGV[1..-1].join(" ")).response
  end

  def route_to_view
    ListView.new(@response)
  end
end

class Model
  attr_reader :response
  def initialize(action, parameter)
    @tasklist = CSV.read("todo.csv").map{ |task| Task.new( task[0...-1].join, (task[-1].strip == 'true') ) }
    @parameter = parameter
    @action = action
    execute
  end

  def execute
    self.send(@action)
    write_to_file
    @response = @tasklist
    to_controller
  end

  def to_controller
   @response
  end

  def add
    @tasklist << Task.new(@parameter, false)
  end

  def delete
    @tasklist.delete_at(@parameter.to_i - 1)
  end

  def complete_task
    @tasklist[@parameter.to_i - 1].done = true
  end

  def write_to_file
    CSV.open('todo.csv', 'w') do |csv|
      @tasklist.each{ |item| csv << [item.task, item.done] }
    end
  end
end


ListController.new
# # -------Driver---Code------
# rocky = List.new
# rocky.send(ARGV[0])


