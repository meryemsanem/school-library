require 'rspec'
require_relative '../classes/teacher'
require_relative '../classes/person'

describe Teacher do
  let(:teacher) { Teacher.new(30, 'Doctor', parent_permission: true) }
  it 'initializes with age, name,specialization and parent permission' do
    expect(teacher.age).to eq(30)
    expect(teacher.specialization).to eq('Doctor')
    expect(teacher.instance_variable_get(:@parent_permission)).to be_truthy
  end
  it 'is a kind of Person' do
    expect(teacher).to be_a(Person)
  end

  it 'can use services without parent permission' do
    teacher_without_permission = Teacher.new(30, 'Doctor', parent_permission: false)
    expect(teacher_without_permission.can_use_services?).to be_truthy
  end
end
