require 'rspec'
require_relative '../classes/student'
require_relative '../classes/person'

describe Student do
  let(:student) { Student.new(16, 'Class', name: 'Bob', parent_permission: true) }

  describe '#initialize' do
    it 'initializes a Student object with age, classroom, name, and parent_permission' do
      expect(student.age).to eq(16)
      expect(student.name).to eq('Bob')
      expect(student.parent_permission).to be true
      expect(student.classroom).to eq('Class')
    end
  end

  describe '#play_hooky' do
    it "returns '¯(ツ)/¯' when called" do
      expect(student.play_hooky).to eq('¯(ツ)/¯')
    end
  end

  describe '#classroom=' do
    it 'sets the classroom and adds the student' do
      classroom = double('Classroom')
      allow(classroom).to receive(:students).and_return([])
      student.classroom = classroom
      expect(student.classroom).to eq(classroom)
      expect(classroom.students).to include(student)
    end

    it "does not add the student to the classroom's students list if already included" do
      classroom = double('Classroom')
      allow(classroom).to receive(:students).and_return([student])
      student.classroom = classroom
      expect(student.classroom).to eq(classroom)
      expect(classroom.students.count).to eq(1)
    end
  end
end
