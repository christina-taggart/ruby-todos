require 'csv'

class List

  def initialize
    @list = []
    CSV.foreach("todo.csv") do |task|
      task_being_added = Task.new(task) #to_boolean(task[1])
      @list << task_being_added
      task_being_added.id = @list.length
    end
    @next_task_id = @list.length + 1
  end



  def add(task_description)
    @task = Task.new([task_description])
    @task.id = @next_task_id
    @next_task_id += 1
    @list << @task
    update_csv
  end

  def delete(id)
    found = false
    @list.each do |task|
      if task.id == id
        @list.delete(task)
        found = true
      end
    end
    if found == false
      puts "This item is not in your list."
    else
      puts "Item has been deleted from the list"
    end
    update_csv

  end

  def complete(id)
    @list.each do |task|
      task.completed = true if task.id == id
    end
    update_csv
  end

  def update_csv
    CSV.open("todo.csv", "w") do |csv|
      @list.each do |item|
        data =  [item.description, item.completed].flatten!
        csv << data
      end
    end
  end

  def to_boolean(str)
      str == 'true'
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
    @list.each do |task|
      if task.completed == true
        prepend = "[X]"
      else
        prepend = "[ ]"
      end
      puts "#{prepend} #{task.description[0]} (ID: #{task.id})"
  end
    # display_completed
    # display_to_do
  end
end


class Task

  attr_accessor :description, :completed, :id

  def initialize(description) #completed
    @completed = false
    @description = description
    @id = id
  end

end



todo_list = List.new()

todo_list.delete(5)
todo_list.add("walk the dog")
todo_list.display_all_tasks
puts "---"
todo_list.complete(4)
todo_list.complete(7)
todo_list.display_all_tasks



# action= ARGV[0]

# case
#   when action == "add"
#       task = ARGV[1..-1].join(" ")
#       todo_list.add(task)
#       p "#{task} has been added to the list"
#   when action == "list"
#     todo_list.display_all_tasks
#   when action == "delete"
#     id = ARGV[1..-1].join(" ").to_i
#     todo_list.delete(id)
#   when action == "complete"
#     id = ARGV[1..-1].join(" ").to_i
#     todo_list.complete(id)
#   else
#     puts "Sorry, you can't do that. Please enter a new command"
# end






