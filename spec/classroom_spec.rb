require 'rspec'
require_relative '../classes/classroom'

describe Classroom do
  let(:classroom) { Classroom.new('Class') }
  let(:student) { double('Student') }

  describe '#initialize' do
    it 'initializes a Classroom object with a label' do
      expect(classroom.label).to eq('Class')
    end

    it 'initializes a Classroom object with an empty students array' do
      expect(classroom.students).to be_empty
    end
  end

  describe '#add_student' do
    it 'sets the classroom of the added student to the current classroom' do
      expect(student).to receive(:classroom=).with(classroom)
      classroom.add_student(student)
    end
  end
end
