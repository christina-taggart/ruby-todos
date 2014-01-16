require 'csv'

module TaskHelpers
  def string_to_bool(string)
    return false if string == "false"
    return true if string == "true"
  end
end


class List
  def initialize
    @tasks = Array.new
  end

  def add_task(task)
    task.increment_id if duplicate_id?(task.task_id)
    @tasks << task
  end

  def remove_task(task_id)
    @tasks.delete_if { |task| task.task_id == task_id}
  end

  def complete_task(task_id)
    @tasks.each { |task| task.complete if task.task_id == task_id }
  end

  def print
    puts self.to_s
  end

  def ljustify_length
    longest_text = @tasks.max do |task1, task2|
      task1.text.length <=> task2.text.length
    end
    longest_text.text.length
  end

  def to_a
    @tasks.map { |task| task.to_a }
  end

  def to_s
    list_string = String.new
    list_string += "\nID\t#{'TASK'.ljust(ljustify_length)}\tCOMPLETE?\n"
    @tasks.each do |task|
      list_string += "#{task.task_id}\t#{task.text.ljust(ljustify_length)}\t#{task.completed_mark}\n"
    end
    list_string
  end

  def duplicate_id?(task_id)
    if @tasks.find { |task| task.task_id == task_id }
      true
    else
      false
    end
  end
end


class Task
  include TaskHelpers
  attr_reader :text, :task_id
  @@task_id_num = 0

  def initialize(text_or_array)
    @@task_id_num += 1
    if text_or_array.class == String
      @task_id = @@task_id_num
      @text = text_or_array
      @completed = false
    elsif text_or_array.class == Array
      @task_id = text_or_array[0].to_i
      @text = text_or_array[1]
      @completed = string_to_bool(text_or_array[2])
    end
  end

  def complete
    @completed = true
  end

  def completed_mark
    @completed ? "[X]" : "[ ]"
  end

  def to_a
    [@task_id, @text, @completed]
  end

  def increment_id
    @task_id += 1
  end
end


class ListInterface
  @@csv_file_path = "todo.csv"
  def initialize
    @command = ARGV[0]
    @argument = ARGV[1..-1]
  end

  def run!
    user_list = load_csv
    case @command
      when "complete"
        task_id = @argument[0].to_i
        user_list.complete_task(task_id)
      when "add"
        text = @argument.join(" ")
        user_list.add_task(Task.new(text))
      when "delete"
        task_id = @argument[0].to_i
        user_list.remove_task(task_id)
      when "list"
        user_list.print
      else
        puts "Invalid command."
    end
    save_csv(user_list)
    save_txt(user_list)
  end

  def load_csv
    list = List.new
    CSV.foreach(@@csv_file_path) do |row|
      task = Task.new(row)
      list.add_task(task)
    end
    list
  end

  def save_csv(list)
    CSV.open(@@csv_file_path, "w") do |csv|
      list.to_a.each { |task| csv << task }
    end
  end

  def save_txt(list)
    File.open("todo.txt", 'w') { |file| file.write(list.to_s) }
  end
end

#----DRIVERS-----

# def assert(error_message, test)
#   raise error_message unless test
# end

# test_list = List.new
# test_list.add_task(Task.new("Buy some milk"))
# test_list.add_task(Task.new("Pay bills"))
# test_list.add_task(Task.new("Fix Car"))
# test_list.print
# test_list.remove_task(2)
# test_list.print
# test_list.add_task(Task.new("Study"))
# test_list.print
# test_list.complete_task(4)
# test_list.print

#-----RUN THE INTERFACE-----
the_interface = ListInterface.new
the_interface.run!