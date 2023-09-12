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
          puts "Person ID: #{rental.person.id}, Date: #{rental.date}, Book '#{rental.book.title}' by
          #{rental.book.author}"
        end
      end
    end
  end

  def load_data
  # Load books data
  @books = ReadFile.new('books.json').read.map { |book| Book.new(book['title'], book['author']) }

  # Load people data
  people_data = ReadFile.new('people.json').read || []

  # Initialize separate lists for students and teachers
  students = []
  teachers = []

  # Iterate over the loaded data and assign IDs consistently
  people_data.each do |person|
    if person['type'] == 'student'
      age = person['age']
      name = person.key?('name') ? person['name'] : 'Unknown'
      student = Student.new(age, person['parent_permission'], name: name)
      student.id = person['id']
      students.push(student)
    elsif person['type'] == 'teacher'
      age = person['age']
      specialization = person['specialization']
      name = person.key?('name') ? person['name'] : 'Unknown'
      teacher = Teacher.new(age, specialization, name: name)
      teacher.id = person['id']
      teachers.push(teacher)
    end
  end

  # Set the @people instance variable to the merged list of students and teachers
  @people = students + teachers
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
