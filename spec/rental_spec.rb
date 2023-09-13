require 'rspec'
require_relative '../classes/rental'
require_relative '../classes/book'
require_relative '../classes/person'

describe Rental do
  let(:book) { Book.new('Title', 'Author') }
  let(:person) { Person.new(25, 'John', parent_permission: false) }
  let(:date) { '2023-09-13' }
  let(:rental) { Rental.new(date, book, person) }

  before do
    rental
  end
  it 'initializes with date, book, and person' do
    rental = Rental.new(date, book, person)
    expect(rental.date).to eq(date)
    expect(rental.book).to eq(book)
    expect(rental.person).to eq(person)
  end
  it 'can add a rental to  rentals' do
    rental = Rental.new(date, book, person)
    expect(book.rentals).to include(rental)
  end
end
