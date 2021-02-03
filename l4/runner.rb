require './todo.rb'
require './connect_db'
require 'date'

date = Date.today
todos = [
  { text: "Submit assignment", due_date: date - 1, completed: false },
  { text: "Pay rent", due_date: date, completed: true },
  { text: "File taxes", due_date: date + 1, completed: false },
  { text: "Call Acme Corp.", due_date: date + 1, completed: false },
]

# Constructor - (text, date, complted)

connect_db!
todos = todos.map { |todo|
  Todo.add_task({todo_text: todo[:text], due_in_days: todo[:due_date] - Date.today})
}
