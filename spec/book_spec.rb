require 'rspec'
require_relative '../classes/book'

describe Book do
  let(:book) { Book.new('The Book', 'Bob') }

  describe '#initialize' do
    it 'initializes a Book object with title and author' do
      expect(book.title).to eq('The Book')
      expect(book.author).to eq('Bob')
    end

    it 'initializes a Book object with an empty rentals array' do
      expect(book.rentals).to be_empty
    end
  end

  describe '#add_rental' do
    it "adds a rental to the book's rentals array" do
      rental = 'Rental information'
      book.add_rental(rental)
      expect(book.rentals).to include(rental)
    end
  end
end
