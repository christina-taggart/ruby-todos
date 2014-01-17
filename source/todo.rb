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
    @tasks << task
  end

  def remove_task(task_id)
    @tasks.delete_at(task_id-1)
  end

  def complete_task(task_id)
    @tasks[task_id-1].complete
  end

  def print
    puts self.to_s
  end

  def to_a
    @tasks.map { |task| task.to_a }
  end

  def to_s
    list_string = String.new
    list_string += "\nID\t#{'TASK'.ljust(ljustify_length)}\tCOMPLETE?\n"
    @tasks.each_with_index do |task, index|
      list_string += "#{index+1}\t#{task.text.ljust(ljustify_length)}\t#{task.completed_mark}\n"
    end
    list_string
  end

  private

  def ljustify_length
    longest_text = @tasks.max do |task1, task2|
      task1.text.length <=> task2.text.length
    end
    longest_text.text.length
  end
end


class Task
  include TaskHelpers
  attr_reader :text
  def initialize(text_or_array)
    if text_or_array.class == String
      @text = text_or_array
      @completed = false
    elsif text_or_array.class == Array
      @text = text_or_array[0]
      @completed = string_to_bool(text_or_array[1])
    end
  end

  def complete
    @completed = true
  end

  def completed_mark
    @completed ? "[X]" : "[ ]"
  end

  def to_a
    [@text, @completed]
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
        user_list.print
      when "add"
        text = @argument.join(" ")
        user_list.add_task(Task.new(text))
        user_list.print
      when "delete"
        task_id = @argument[0].to_i
        user_list.remove_task(task_id)
        user_list.print
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