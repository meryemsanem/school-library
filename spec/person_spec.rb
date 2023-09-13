require 'rspec'
require_relative '../classes/person'

describe Person do
  let(:person) { Person.new(25, 'John', parent_permission: false) }

  it 'initializes with age, name, and parent permission' do
    expect(person.age).to eq(25)
  end
end
