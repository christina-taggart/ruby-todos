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
  def initialize(tasklist)
    @tasklist = tasklist
  end

  def add(new_task)
    system("clear")
    @tasklist << Task.new(new_task)
    print
  end

  def delete(task_num)
    system("clear")
    puts "Deleted '#{@tasklist[task_num-1].task}' from your TODO list"
    @tasklist.delete_at(task_num-1)
    print
  end

  def complete_task(task_num)
    system("clear")
    @tasklist[task_num - 1].done = true
    puts "'#{@tasklist[task_num-1].task}' has been marked Complete."
    print
  end

  def print
    puts "\nThings to do:\n\n"
    @tasklist.each_with_index { |task, index| puts "#{(index+1).to_s.rjust(2)}.   #{task.done ? '[X]' : '[ ]'}   #{task.task}" }
  end
end

class Task
  attr_accessor :done, :task
  def initialize(task, done=false)
    @task = task
    @done = done
  end
end

# Separate List (our model/controller) from our viewer with
# a new object ListInterface:
class ListInterface
  def initialize
    @command = ARGV[0]
    @argument = ARGV[1..-1]
  end

  def run!
    user_list = List.new(open_file)
    case @command
    when "add"
      user_list.add(@argument.join(" "))
    when "delete"
      user_list.delete(@argument.join.to_i)
    when "complete_task"
      user_list.complete_task(@argument.join.to_i)
    when "print"
      user_list.print
    else
      puts "Invalid command."
    end
    write_to_file(user_list)
  end

  def open_file
    CSV.read("todo.csv").map{ |task| Task.new( task[0...-1].join, (task[-1].strip == 'true') ) }
  end

  def write_to_file(list)
    CSV.open('todo.csv', 'w') do |csv|
      list.tasklist.each{ |item| csv << [item.task, item.done] }
    end
  end
end

#-------Driver---Code------
viewer = ListInterface.new
viewer.run!
