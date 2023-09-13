require 'rspec'
require_relative '../classes/person'

describe Person do
  let(:person) { Person.new(25, 'John', parent_permission: false) }

  it 'initializes with age, name, and parent permission' do
    # Initializes with age, name, and parent permission and empty rentals array
    expect(person.age).to eq(25)
    expect(person.name).to eq('John')
    expect(person.parent_permission).to be_falsey
    expect(person.rentals).to eq([])
  end

  it 'initializes with a unique ID' do
    # Initializes with a unique ID
    expect(person.id).to be_a(Integer)
  end

  it 'initializes with default name "Unknown" if name is not provided' do
    # Tested the scenario of an unknown name; if the name is not provided, the default name should be Unknown.
    # The constructor method sets a default value for the optional name parameter if it is not provided.
    person_without_name = Person.new(30)
    expect(person_without_name.name).to eq('unknown')
  end

  it 'can use services with parent permission' do
    # Tested the context when checking permissions
    # Tested can_use_services? method returns false if under age and no parent permission
    person_with_permission = Person.new(15, 'Bob', parent_permission: true)
    expect(person_with_permission.can_use_services?).to be_truthy
  end

  it 'cannot use services without parent permission if under age' do
    # Tested the context when checking permissions
    # Tested can_use_services? method returns false if under age and no parent permission
    underage_person = Person.new(16, 'Alice', parent_permission: false)
    expect(underage_person.can_use_services?).to be_falsey
  end

  it 'can use services without parent permission if over age' do
    # Tested the context when checking permissions
    # Tested can_use_services? method returns true if over age
    adult_person = Person.new(18, 'Eve', parent_permission: false)
    expect(adult_person.can_use_services?).to be_truthy
  end

  it 'correctly returns the name' do
    # Tested the context when validating the name
    expect(person.correct_name).to eq('John')
  end

  it 'does not correct the name' do
    # Tested the context when validating the name
    person_with_long_name = Person.new(30, 'alongnameiscorrected')
    expect(person_with_long_name.correct_name).to eq('alongnameiscorrected')
  end

  it 'can add a rental and return it' do
    # Tested the context when adding a new rental so the add_rental method returns a rental and adds it to the book.
    rental = double('Rental')
    expect(person.add_rental(rental)).to eq([rental])
    expect(person.rentals).to include(rental)
  end
end
