require 'csv'

module Model

  def save_file_csv!(list)
    CSV.open('todo.csv', "wb") do |csv|
      csv << ["description", "completed"]
      list.tasks.map do |task|
        csv << [task.description, task.complete? ? "complete" : "incomplete"]
      end
    end
  end

  def save_file_txt!(list)
    File.open('todo_out.txt', 'w') do |file|
      list.tasks.each_with_index do |task,idx|
        file.write("#{idx+1}.".ljust(3) + " [#{ task.complete? ? "X" : " " }] #{task.description}\n")
      end
    end
  end

  def load_file_csv
    tasks_array = []
    keys = []
    CSV.foreach('todo.csv') do |row|
       if $. == 1
          keys = row.map{ |element| element.to_sym }
        else
         hash = Hash.new
         row.each_with_index { |element, i|  hash[keys[i]] = element }
         tasks_array << hash
       end
    end
    tasks_array
  end

  def load_file_txt
    tasks_array = []
    File.open('todo_out.txt', 'r+') do |f|
      f.each do |line|
        hash = Hash.new
        matches = /^\d*[\. ]*\[(.)\] (.*)/.match("#{line}")
        if matches[1] == "X"
          comp_string = "complete"
        else
          comp_string = "incomplete"
        end
        hash[:completed] = comp_string
        hash[:description] = matches[2]
        tasks_array << hash
      end
    end
    tasks_array
  end

  def make_list_from_task_array(task_array, list)
    task_array.each do |task_hash|
      task = Task.new(task_hash[:description])
      task.complete! if task_hash[:completed] == "complete"
      list.add(task)
    end
  end
end

class List

  attr_reader :tasks

  def initialize
    @tasks = []
  end

  def add(*tasks)
    tasks.each{ |task| @tasks << task }
  end

  def length
    @tasks.length
  end

  def complete!(id)
    task_by_id(id).complete!
    task_by_id(id)
  end

  def delete!(id)
    @tasks.delete_at(id - 1)
  end

  def task_by_id(id)
    @tasks[id - 1]
  end

  def to_s
    output = ""
    @tasks.each_with_index{ |task, id| output += "#{id + 1}".ljust(2) + " #{task.to_s}\n" }
    output
  end
end

class Task
  attr_reader :description

  def initialize(description)
    @description = description
    @is_completed = false
  end

  def complete?
    @is_completed
  end

  def complete!
    @is_completed = true
  end

  def to_s
    "[#{ @is_completed? "X" : " " }] #{@description}"
  end
end