# What classes do you need?


class Task
  attr_accessor :text, :completed, :id
  def initialize(text, id)
    @text = text
    @id = id
    @completed = false
  end
end


# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# list = List.new
# list.add(Task.new("walk the dog"))
# tasks = list.tasks
# list.get_all
# list.delete (task_id)

class List
  attr_accessor :tasks
  def initialize
    @tasks = []
    @command = ARGV.join(" ").chomp
    get_tasks
    do_command
  end

  def get_tasks
    File.open('todo.csv', 'r+') do |f|
      id = 1
      until f.eof?
        @tasks << Task.new(f.readline, id)
        id += 1
      end
    end
  end

  def display_tasks
    @tasks.each {|task| puts "#{task.id} " + task.text}
  end

  def delete(id)
    @tasks.delete_at(id.to_i - 1)
    puts "Deleted Task"
    update_tasks
  end

  def update_tasks
    File.open('todo.csv', 'w') do |f|
      @tasks.each do |task|
        f.puts "#{task.id} " + task.text
      end
    end
  end

  def complete(id)
    @tasks.delete_at(id.to_i - 1)
    puts "Good Job!"
    update_tasks
  end

  def add_task(text)
    @tasks << Task.new(text, @tasks.length + 1)
    update_tasks
    puts "Added Task"
  end

  def do_command
    first_word = @command.split(" ")[0]
    rest_of_command = @command.split(" ")[1..-1].join(" ")
    if first_word == "add"
      add_task(rest_of_command)
    elsif first_word == "delete"
      delete(rest_of_command)
    elsif first_word == "complete"
      complete(rest_of_command)
    elsif first_word == "list"
      display_tasks
    else
      puts "invalid command"
    end
  end
end

my_list = List.new




