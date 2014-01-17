
require_relative 'controller.rb'
interpreter = CommandInterpreter.new(ARGV)
interpreter.run_program

# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# Classes:
# - Task
# - List
# - View - displays output and receives input



# list = List.new
# # p list.tasks
# task1 = Task.new("get milk")
# task2 = Task.new("mow lawn")
# task3 = Task.new("eat")
# list.add(task1, task2)
# list.add(task3)
# # p list.length == 2

# puts list
# puts"========"
# # p task 1
# list.delete!(1)
# list.complete!(2)
# puts list
# how do i get "get milk task" ?

# task = Task.new("wash car")
# p task.complete? == false
# p task
# task.complete!
# p task.complete? == true
# p task




# tasks = []
# CSV.foreach(ARGV[0]) { |row| tasks << Task.new(row[0]) }

# loaded_list = List.new(*tasks)
# puts loaded_list.to_s

# commands:
# add
# delete
# complete
# filename
# list - default

