require './classes/app'
require './classes/execute_option'
app = App.new

def main(app)
  puts 'Welcome to School Library App!'
  loop do
    puts 'Please choose an option by enterin a number:'
    puts '1 - List all books'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given person id'
    puts '7 - Exit'

    number = gets.chomp.to_i
    break if number == 7

    execute_option(app, number)
  end
end

main(app)
