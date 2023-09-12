require 'json'
require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'classroom'
require_relative 'preserve_data'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def create_person
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    type = gets.chomp.to_i
    case type
    when 1
      create_student
    when 2
      create_teacher
    else
      puts 'Invalid input. Please enter 1 for a student or 2 for a teacher.'
    end
  end

  def create_student
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
    print 'Has parent permission? [Y/N]: '
    parent_permission = gets.chomp
    person = Student.new(age, parent_permission, name: name)
    @people.push(person)
    puts "Student '#{name}' created successfully"
  end

  def create_teacher
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
    print 'Specialization: '
    specialization = gets.chomp
    person = Teacher.new(age, specialization, name: name)
    @people.push(person)
    puts "Teacher '#{name}' created successfully"
  end

  def create_book
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp
    book = Book.new(title, author)
    @books.push(book)
    puts "Book '#{title}' created successfully"
  end

  def create_rental
    book_index = select_book
    person_index = select_person
    print 'Date: '
    date = gets.chomp
    @rentals.push(Rental.new(date, @books[book_index], @people[person_index]))
    puts 'Rental created successfully'
  end

  def select_book
    puts 'Select a book from the following list by number:'
    list_books
    gets.chomp.to_i
  end

  def select_person
    puts 'Select a person from the following list by number (not id):'
    list_people
    gets.chomp.to_i
  end

  def list_books
    @books.each_with_index do |book, index|
      puts "#{index} - Title: #{book.title}, Author: #{book.author}"
    end
  end

  def list_people
    @people.each_with_index do |person, index|
      type = person.instance_of?(Student) ? 'Student' : 'Teacher'
      puts "#{index} - [#{type}]  Age: #{person.age}, Name: #{person.name}, ID: #{person.id},"
    end
  end

  def list_rentals
    if @rentals.empty?
      puts 'There are no rentals to show'
    else
      puts 'ID of person: '
      person_id = gets.chomp.to_i
      puts 'Rentals: '
      @rentals.each do |rental|
        if person_id == rental.person.id
          puts "Date: #{rental.date}, Book '#{rental.book.title}' by #{rental.book.author}"
        end
      end
    end
  end

def load_data
  @books = ReadFile.new('books.json').read.map { |book| Book.new(book['title'], book['author']) }

  people_data = ReadFile.new('people.json').read
  @people = people_data.map do |person|
    if person['type'] == 'student'
      Student.new(person['age'], person['name'])
    elsif person['type'] == 'teacher'
      Teacher.new(person['age'], person['specialization'])
    end
  end
end


def save_data
  # Store books data
  books_data = @books.map { |book| { title: book.title, author: book.author } }
  WriteFile.new('books.json').write(books_data)

  # Store people data only if there are people objects
  if @people.any?
    people_data = @people.map do |person|
      if person.is_a?(Student)
        { type: 'student', age: person.age, name: person.name }
      elsif person.is_a?(Teacher)
        { type: 'teacher', age: person.age, name: person.name, specialization: person.specialization }
      end
    end
    WriteFile.new('people.json').write(people_data)
  end

  # Store rentals data if available
  if @rentals.any?
    rentals_data = @rentals.map do |rental|
      { date: rental.date, book: rental.book.to_json, person: rental.person.to_json }
    end
    WriteFile.new('rentals.json').write(rentals_data)
  end
end





end
