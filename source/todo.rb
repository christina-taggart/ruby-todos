# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# 


class ToDo
	def initialize
		@todo_array = []
		tasks = File.open("todo.csv", "r")
		
		tasks.each { |item| 
			if item.include?('[ ]' || '[x]')
				@todo_array.push(item.chomp)
			else
				@todo_array.push(item.insert(0, '[ ] ').chomp)
			end
		}
		
		@task = ARGV.values_at(1..ARGV.length-1).join(" ")
		@match_task = @task.insert(0, '[ ] ')


		if ARGV[0].to_s.downcase == "add"
			add
		elsif ARGV[0].to_s.downcase == "delete"
			delete
		elsif ARGV[0].to_s.downcase == "complete"
			complete
		elsif ARGV[0].to_s.downcase == "list"
			list
		else
			puts "Invalid option. Valid options are \"add\", \"delete\", \"complete\", and \"list\""
		end
	end

	def add
		puts @task
		p "Adding '#{@task}' to To Do list"
		@todo_array.push(@task)
		
		task_file = File.open("todo.csv", "w")
		task_file.puts @todo_array

	end

	def delete
		p "Removing '#{@task}' from To Do list"
		@todo_array.delete(@task)

		task_file = File.open("todo.csv", "w")
		task_file.puts @todo_array
	end

	def complete
		if @todo_array.include?(@task)
			@todo_array.each_with_index { |value, index| 
				if value == @match_task 
					@todo_array[index]["[ ] "]="[x] "
					puts @todo_array
				end
			}
		else
			puts "The '#{@task}' task is not on the to do list. Please add it first"
		end

		task_file = File.open("todo.csv", "w")
		task_file.puts @todo_array
	end

	def list
		@todo_array.each { |x| puts x	}
	end

end

my_task = ToDo.new

