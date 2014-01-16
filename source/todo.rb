# What classes do you need?
  #class List
    #methods: add, delete, etc
    #class Task: what the task is

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
  #add a task to a list
  #remove a task from a list
  #mark a task as completed

# 2. Displaying information to the user (view)
  #display all tasks in the list
  #display all completed tasks
  #display all uncompleted tasks

#3. Reading and writing from the todo.txt file (model)
  #reading: fetch all tasks in .txt file and add to list object
  #writing: write all tasks in list object to .txt file
  #mark tasks in file as completed or not

# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)


# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).
require 'csv'
class List
  attr_accessor :tasklist
  def initialize
    @tasklist = CSV.read("todo.csv").map{ |task| Task.new( task.join(" ") ) }
  end

  def add(new_task = ARGV[1..-1].join(" "))
    @tasklist << Task.new(new_task)
    write_to_file
  end

  def delete(task_num = ARGV[1..-1].join.to_i)
    @tasklist.delete_at(task_num-1)
    write_to_file
  end

  def write_to_file
    CSV.open('todo.csv', 'w') do |csv|
      @tasklist.each{ |item| csv << ["#{item.task}"] }
    end
  end

  def print
    i=1
    @tasklist.each do |task|
      puts "#{i}: #{task.task}"
      i+=1
    end
  end
end

class Task
  attr_accessor :done, :task
  def initialize(task)
    @task = task
    @done = false
  end
end

#-------Driver---Code------
rocky = List.new
rocky.send(ARGV[0])
