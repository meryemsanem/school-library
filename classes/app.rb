require 'json'
require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'classroom'
require_relative 'preserve_data'
# rubocop:disable Metrics/ClassLength
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
  puts 'Enter the ID of the person: '
  person_id = gets.chomp.to_i
  puts 'Rentals: '
  person_rentals = @rentals.select { |rental| rental.person.id == person_id }
  if person_rentals.empty?
    puts 'No rentals found for this person.'
  else
    person_rentals.each do |rental|
      puts "Rental ID: #{rental.rental_id}, Date: #{rental.date}, Book '#{rental.book.title}' by #{rental.book.author}"
    end
  end
end

  def load_data
    load_books_data
    load_people_data
  end

  def load_books_data
    @books = ReadFile.new('books.json').read.map { |book| Book.new(book['title'], book['author']) }
  end

  def load_people_data
    people_data = ReadFile.new('people.json').read || []
    students = []
    teachers = []

    people_data.each do |person|
      if person['type'] == 'student'
        students.push(load_student_data(person))
      elsif person['type'] == 'teacher'
        teachers.push(load_teacher_data(person))
      end
    end

    @people = students + teachers
  end

  def load_student_data(data)
    age = data['age']
    name = data.key?('name') ? data['name'] : 'Unknown'
    student = Student.new(age, data['parent_permission'], name: name)
    student.id = data['id']
    student
  end

  def load_teacher_data(data)
    age = data['age']
    specialization = data['specialization']
    name = data.key?('name') ? data['name'] : 'Unknown'
    teacher = Teacher.new(age, specialization, name: name)
    teacher.id = data['id']
    teacher
  end

  def save_data
    save_books
    save_people
    save_rentals
  end

  def save_books
    # Store books data
    books_data = @books.map { |book| { title: book.title, author: book.author } }
    WriteFile.new('books.json').write(books_data)
  end

  def save_people
    # Store people data only if there are people objects
    return unless @people.any?

    students_data = @people.select { |person| person.is_a?(Student) }.map do |student|
      { type: 'student', id: student.id, age: student.age, name: student.name }
    end

    teachers_data = @people.select { |person| person.is_a?(Teacher) }.map do |teacher|
      { type: 'teacher', id: teacher.id, age: teacher.age, name: teacher.name,
        specialization: teacher.specialization }
    end

    people_data = students_data + teachers_data
    WriteFile.new('people.json').write(people_data)
  end

  def save_rentals
    # Store rentals data if available
    return unless @rentals.any?

    existing_rentals = ReadFile.new('rentals.json').read || [] # Load existing rentals
    rentals_data = existing_rentals + @rentals.map do |rental|
      {
        date: rental.date,
        book: { title: rental.book.title, author: rental.book.author },
        person: { type: rental.person.class.to_s.downcase, id: rental.person.id, age: rental.person.age,
                  name: rental.person.name }
      }
    end
    WriteFile.new('rentals.json').write(rentals_data)
  end
end

def list_rentals
  rentals_data = ReadFile.new('rentals.json').read

  if rentals_data.nil? || rentals_data.empty?
    puts 'There are no rentals to show'
  else
    rentals_data.each do |rental_data|
      date = rental_data['date']
      book_data = rental_data['book']
      person_data = rental_data['person']
      book_title = book_data['title']
      book_author = book_data['author']
      person_id = person_data['id']
      person_name = person_data['name']

      puts "Date: #{date}"
      puts "Book: '#{book_title}' by #{book_author}"
      puts "Person ID: #{person_id}, Name: #{person_name}"
      puts '-' * 40
    end
  end
end
# rubocop:enable Metrics/ClassLength
