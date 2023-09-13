require 'rspec'
require_relative '../classes/teacher'

describe Teacher do
  let(:teacher) { Teacher.new(30, 'Doctor', parent_permission: true) }
  it 'initializes with age, name,specialization and parent permission' do
    expect(teacher.age).to eq(30)
    expect(teacher.specialization).to eq('Doctor')
    expect(teacher.instance_variable_get(:@parent_permission)).to be_truthy
  end
end
