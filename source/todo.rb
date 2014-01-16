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

class Item
  attr_accessor :done
  attr_reader :content, :priority
  def initialize(content, priority)
    @content = content
    @priority = priority
    @done = false
  end
  def found_item?(string)
    @content == string
  end
end

class List
  attr_reader :list
  def initialize
    @list = []
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

end

list = List.new
list.add("item 1",3)
list.add("item 2")
p list.list

p "--------------"
item = Item.new("this is an item", 3)
# p item.found_item?("this is an item") == true
list.remove_item("item 1")
p list.list



# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).