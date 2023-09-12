class Rental
  attr_accessor :date
  attr_reader :book, :person

  def initialize(id, date, book, person)
    @id = Random.rand(1..1000)
    @date = date
    @book = book
    @person = person
    book.add_rental(self)
    person.add_rental(self)
  end
end
