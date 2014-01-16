require 'csv'

class List

  def initialize
    @to_do = []
  end

  def add
    @to_do << @tasks
  end

  def display
    @to_do if ARGV[0] == "list"
  end

end

class Task
  attr_reader :tasks

  def initialize
    @tasks = []
  end

  def add_task
    @tasks << ARGV[1] if define_input[0] == "add"
    @tasks
  end

  def complete_task
    @tasks[task_index].sub!("[ ]", "[X]") if define_input[0] == "complete"
    @tasks
  end

  def delete_task
    @tasks.delete_at(task_index) if define_input[0] == "delete"
    @tasks
  end

  def parse_csv
    CSV.foreach("todo.csv") { |csv| @tasks << csv.join('') }
  end

  private

  def define_input
    ARGV
  end

  def task_index
    ((ARGV[1].to_i)-1)
  end

end

new_task = Task.new
list = List.new
new_task.parse_csv
new_task.add_task
new_task.delete_task
new_task.complete_task
list.add
#puts list.display

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).