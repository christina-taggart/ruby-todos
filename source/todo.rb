# What classes do you need?

=begin
item class - something that holds the todo item
              -initialize
              -content
              -done/completed
              -id
              -mark something as done
              -priority
list class - an aggregate of items;
              -remove item from list
              -add item from list
              -print out list/ highest priority first
              -length
              -sort based on priority
              -list name
              -done?
              -data structure - hash

read/write module
              -grab csv
              -write csv

=end
require 'csv'

class Item
  attr_accessor :done
  attr_reader :content, :priority
  def initialize(content, priority=3)
    @content = content
    @priority = priority
    @done = false
  end
  def found_item?(string)
    @content == string
  end
end

class List # controller?
  attr_reader :list
  def initialize
    @list = []
    @list = Model.pull_file(self)
  end
  def add(content, priority = 3)
    @list << Item.new(content, priority)
  end
  def remove_done
    @list.delete_if { |item| item.done }
  end
  def remove_item(string)
    @list.delete_if { |item| item.found_item?(string) }
  end
  def mark_as_complete(string)
    @list.each do |item|
      if item.found_item?(string)
        item.done = true
      end
    end
  end
  def sort_by_priority!
    @list.sort! { |item1, item2| item2.priority <=> item1.priority }
  end
  def display_list
    sort_by_priority!
    @list.each {|item| puts "#{item.priority} - #{item.content}" }
  end
end

class Model
  def self.pull_file(list_object)
    CSV.foreach("todo.csv") { |row| list_object.list << row }
    list_object.list.flatten!
    make_item_objects(list_object)
  end
  def self.make_item_objects(list_object)
    list_object.list.map {|item| Item.new(item)}
  end
end


list = List.new
p list.list
# list.add("item 1", 3)
# list.add("item 2")

# Model.pull_file(list)

#   list.send ARGV[0].to_sym, *ARGV[1], *ARGV[2].to_i

# list.display_list

# p list.list

# p "--------------"
# item = Item.new("this is an item", 3)
# # p item.found_item?("this is an item") == true
# list.remove_item("item 1")
# p list.list
# p "--------------"
# list.mark_as_complete("item 2")
# p list.list
# p list.remove_done
# p "--------------"
# list.add("Really important", 5)
# list.add("Kind of important", 3)
# list.add("Not important", 1)
# list.add("indifferent", 2)
# # list.sort_by_priority!
# list.display_list


# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).
