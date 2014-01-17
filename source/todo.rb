require 'csv'

# What classes do you need?
class List

  def initialize
    @list = []
    CSV.foreach("todo.csv") do |task|
      @list << Task.new(task)
    end

  end

  def add(task_description)
    @task = Task.new([task_description])
    @list << @task

    update_csv
  end

  def delete(task_to_delete)
    found = false
    @list.each do |task|
      if task.description[0] == task_to_delete
        @list.delete(task)
        found = true
      end
    end
    if found == false
      puts "This item is not in your list."
    else
      puts "#{task_to_delete} has been deleted from the list"
    end
    update_csv

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
    #
    @list.each {|task| puts task.description}

    # display_completed
    # display_to_do
  end

  def update_csv
    #p @list
    CSV.open("todo.csv", "wb") do |csv|
      @list.each {|item| csv << item.description}
    end
  end
end


class Task

  attr_accessor :description, :completed, :id

  def initialize(description)
    @completed = false
    @description = description
    @id = id
  end

  def complete
    @completed = true
  end

end



todo_list = List.new()
#todo_list.display_all_tasks

todo_list.add("walk the dog")
todo_list.delete("Move with Lil to the black mountain hills of Dakota")
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