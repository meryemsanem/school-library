require_relative '../classes/trimmer_decorator'
require_relative '../classes/person'

describe TrimmerDecorator do
  let(:person) { Person.new(22, 'maximilianus') }
  let(:decorated_person) { TrimmerDecorator.new(person) }

  it 'correctly trims a long name' do
    person.name = 'verylongname'
    expect(decorated_person.correct_name).to eq('verylongna')
  end
  it 'does not trim a name of exactly 10 characters' do
    person.name = '1234567890'
    expect(decorated_person.correct_name).to eq('1234567890')
  end
end
