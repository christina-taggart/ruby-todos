require 'csv'

class Item
  attr_accessor :done
  attr_reader :content
  def initialize(content)
    @content = content
    @done = false
  end
  def found_item?(string)
    @content == string
  end
end

class List # controller?
  attr_reader :list
  def initialize
    @list = Model.pull_file
  end
  def add(content)
    @list << Item.new(content)
    Model.push_file(@list.to_a) # get into array
  end
  def remove_done
    @list.delete_if { |item| item.done }
  end
  def remove_item(string)
    @list.delete_if { |item| item.found_item?(string) }
  end
  def mark_as_complete(string)
    @list.each { |item| item.done = true if item.found_item?(string) }
  end
  def display_list
    @list.each {|item| puts "#{item.content}" }
  end
  def save
    Model.push_file(@list.to_a) #get into array
  end
end

class Model
  def self.pull_file
    file_array = Array.new
    CSV.foreach("todo.csv") { |row| file_array << row }
    file_array.flatten!
    make_item_objects(file_array)
  end
  def self.make_item_objects(file_array)
    file_array.map {|item| Item.new(item)}
  end
  def self.push_file(file_array)
    CSV.open("todo.csv") do |csv|
      file_array.each do |list_object|
        csv << list_object
      end
    end
  end
end



# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).