require 'csv'

class List

  def initialize(list_of_tasks)
    @to_do = list_of_tasks
    display
    write_all_to_txt
  end

  private

  def display
    puts @to_do if ARGV[0] == "list"
  end

  def write_all_to_txt
    File.open("todo.csv", "w") do |input|
      @to_do.each { |task| input << task + "\n" }
    end
  end

end

class Task

  def initialize
    @tasks = []
    parse_csv
  end

  def add_task
    @tasks << ("[ ]" + ARGV[1]) if define_input[0] == "add"
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

  def route_to_list
    List.new(@tasks)
  end

  private

  def define_input
    ARGV
  end

  def task_index
    ((ARGV[1].to_i)-1)
  end

  def parse_csv
    CSV.foreach("todo.csv") { |csv| @tasks << csv.join('') }
  end

end

new_task = Task.new
new_task.add_task
new_task.delete_task
new_task.complete_task
new_task.route_to_list