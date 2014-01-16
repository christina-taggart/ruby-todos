require 'csv'

# What classes do you need?
class List

  def initialize
    @list = []
  end

  def add(task)
    @task = task
    @list << @task
    CSV.open("todo.csv", "wb") do |csv|
      csv << [@task]
    end
  end

  def delete(task_to_delete)
    found = false
    @list.each do |task|
      if task.description == task_to_delete
        @list.delete(task)
        found = true
      end
    end
    puts "This item is not in your list." if found == false
  end

  def display_completed
    puts "Completed Tasks"
    puts "---------------"
    @list.each {|task| p task.description if task.completed == true}
    puts ""
  end


  def display_to_do
    puts "To Do List"
    puts "---------------"
    @list.each {|task| p task.description if task.completed == false}
    puts ""
  end

  def display_all_tasks
    CSV.foreach("todo.csv") do |task|
      add(Task.new(task))
    end

    @list.each {|task| puts task.description}
    # display_completed
    # display_to_do
  end

end


class Task

  attr_accessor :description, :completed

  def initialize(description)
    @completed = false
    @description = description
  end

  def complete
    @completed = true
  end

end



todo_list = List.new()
#todo_list.display_all_tasks

todo_list.add(Task.new("walk the dog"))
todo_list.display_all_tasks





# action= ARGV[0]

# my_list = List.new

#until ARGV[0] == "exit"

  # case
  #   when action == "add"
  #       task = ARGV[1..-1].join(" ")
  #       my_list.add(task)
  #       p "#{task} has been added to the list"
  #   when action == "list"
  #     my_list.display_all_tasks
  #   when action == "delete"
  #     my_list.delete(task)
  #   else
  #     puts "Sorry, you can't do that. Please enter a new command"
  #     action_item = gets.chomp
  # end
#end





# my_list.add(Task.new("walk the dog"))
# item2 = Task.new("item2")
# my_list.add(item2)
# my_list.add(Task.new("item3"))
# item2.complete
# my_list.delete("item3")

# my_list.display_all_tasks


# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).