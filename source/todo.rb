require 'csv'

class Controller
  attr_reader :user_input, :model_response

  def initialize(user_input = ARGV)
    @user_input = user_input
    @model_response = []
    execute
  end

  def execute
    pass_to_model
    pass_to_view
  end

  def pass_to_model
    @model_response = Model.new(user_input).response
  end

  def pass_to_view
    View.new(model_response)
  end

end

class Model
  attr_reader :command, :user_message, :to_do, :response

  def initialize(user_request)
    @command = user_request.shift
    @user_message = user_request.join(" ")
    @to_do = []
    @response = nil
    execute
  end

  def execute
    parse_items
    run_user_command
    send_response
  end

  def clear_to_do
    @to_do = []
  end

  def parse_items
    clear_to_do
    CSV.foreach("todo.csv", "r") do |item|
      item[1] = "false" if item[1] == nil
      @to_do << Task.new($., item[0], item[1])
    end
  end

  def rewrite_csv
    CSV.open("todo.csv", "w") do |csv|
      @to_do.each do |item|
        csv << [item.task, item.completed]
      end
    end
  end

  def run_user_command
    parse_items
    send(command.to_sym)
  end

  def list
    @response = to_do
  end

  def add
    @to_do << Task.new(to_do.length + 1, user_message, "false")
    process_change
  end

  def delete
    @to_do.delete_if { |item| item.task_id == user_message.to_i }
    process_change
  end

  def complete
    @to_do.each do |item|
      item.completed = "true" if item.task_id == user_message.to_i
    end
    process_change
  end

  def process_change
    rewrite_csv
    parse_items
    list
  end

  def send_response
    @response = to_do
  end

end


class View

  def initialize(model_response)
    @model_response = model_response
    render
  end

  def render
    @model_response.each do |task|
      task.completed == "true" ? checked = "[X]" : checked = "[ ]"
      puts "#{task.task_id}.".ljust(4) + "#{checked} #{task.task}"
    end
  end

end

class Task
  attr_reader :task_id, :task
  attr_accessor :completed

  def initialize(task_id, task, completed)
    @task_id = task_id
    @task = task
    @completed = completed
  end

end


def line(msg)
  puts "\n------ #{msg} ------"
end

Controller.new



