class Task
  attr_accessor :text, :completed, :id
  def initialize(text, id)
    @text = text
    @id = id
    @completed = false
  end
end


class List
  attr_accessor :tasks
  def initialize
    @tasks = []
    @command = ARGV.join(" ").chomp
    get_tasks
    update_tasks
    do_command
  end

  def get_tasks
    File.open('todo.csv', 'r') do |f|
      id = 1
      until f.eof?
        task = Task.new(f.readline, id)
        @tasks << task
        check_comp(task)
        id += 1
      end
    end
  end

  def check_comp(task)
    task.completed = true if task.text.split(" ")[0] == "COMP"
  end

  def display_tasks
    File.open('todo.csv', 'r') do |f|
      until f.eof?
        puts f.readline
      end
    end
  end

  def display_new
    File.open('todo.txt', 'r') do |f|
      until f.eof?
        puts f.readline
      end
    end
  end

  def delete(id)
    @tasks.delete_at(id.to_i - 1)
    puts "Deleted Task"
    update_tasks
  end

  def update_tasks
    update_txt
    update_csv
  end

  def update_csv
    File.open('todo.csv', 'w') do |f|
      @tasks.each do |task|
        f.print "COMP " if task.completed
        f.print task.text
      end
    end
  end

  def update_txt
    File.open('todo.txt', 'w') do |f|
      @tasks.each do |task|
        f.print "#{task.id}. "
        f.print " [  ] " if task.completed == false
        f.print " [ X ] " if task.completed
        task.text.gsub!("COMP", "")
        f.print task.text
      end
    end
  end

def complete(id)
  @tasks[id.to_i - 1].completed = true
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
    display_new
  else
    puts "invalid command"
  end
 end
end

my_list = List.new




