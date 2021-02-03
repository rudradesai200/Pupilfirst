require 'active_record'
require "date"

class Todo < ActiveRecord::Base

  def overdue? ; (Date.today > due_date) end

  def due_today? ; (Date.today == due_date) end

  def due_later? ; (Date.today < due_date) end

  def completed? ; completed end

  def self.mark_as_complete!(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end

  def self.add_task(h)
    Todo.create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  def to_displayable_string
    ret_str = "#{id}. "
    ret_str += completed ? "[X] " : "[ ] "
    ret_str += "#{todo_text}"
    ret_str += due_today? ? "" : " #{due_date}"
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts Todo.
            where("due_date > '#{Date.today}'").
            map { |todo| todo.to_displayable_string }.
            join("\n")
    puts "\n\n"

    puts "Due Today\n"
    puts Todo.
            where("due_date = '#{Date.today}'").
            map { |todo| todo.to_displayable_string }.
            join("\n")
    puts "\n\n"

    puts "Due Later\n"
    puts Todo.
            where("due_date < '#{Date.today}'").
            map { |todo| todo.to_displayable_string }.
            join("\n")
    puts "\n"
  end
end
