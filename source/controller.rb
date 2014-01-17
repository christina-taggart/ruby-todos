require_relative 'model.rb'


class CommandInterpreter

  include Model

  def initialize(args)
    @args = args
    @list = List.new
  end

  def run_program
    task_array = load_file_txt
    load_file_txt
    make_list_from_task_array(task_array, @list)
    execute_command
    # save_file_txt!(@list)
  end

  def execute_command
    case @args[0]
    when "add"
      add_task
    when "delete"
      delete_task
    when "complete"
      complete_task
    else
      print_list
    end
  end

  def print_list
    puts @list
  end

  def add_task
    new_task = Task.new(@args[1..-1].join(' '))
    @list.add(new_task)
    puts "Added \"#{new_task.description}\" to your TODO list"
  end

  def delete_task
    delete_index = @args[1].to_i
    if delete_index.between?(1, @list.length)
      task = @list.delete!(delete_index)
      puts "Deleted #{task.description} from your TODO list"
    else
      puts "Invalid task, task has #{@list.length} items"
    end
  end

  def complete_task
    complete_index = @args[1].to_i
    if complete_index.between?(1, @list.length)
     task = @list.complete!(complete_index)
      puts "Completed #{task.description} on your TODO list"
    else
      puts "Invalid task, task has #{@list.length} items"
    end
  end
end
