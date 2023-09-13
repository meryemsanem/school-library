require 'rspec'
require_relative '../classes/person'

describe Person do
  let(:person) { Person.new(25, 'John', parent_permission: false) }

  it 'initializes with age, name, and parent permission' do
    expect(person.age).to eq(25)
    expect(person.name).to eq('John')
    expect(person.instance_variable_get(:@parent_permission)).to be_falsey
  end

  it 'correctly returns the name' do
    expect(person.correct_name).to eq('John')
  end

  it 'initializes with a unique ID' do
    expect(person.instance_variable_get(:@id)).to be_a(Integer)
  end
  it 'can use services with parent permission' do
    person = Person.new(15, 'Bob', parent_permission: true)
    expect(person.can_use_services?).to be_truthy
  end
end
