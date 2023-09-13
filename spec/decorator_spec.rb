require 'rspec'
require_relative '../classes/decorator'
require_relative '../classes/nameable'

describe Decorator do
  let(:nameable) { double('Nameable') }
  let(:decorator) { Decorator.new(nameable) }

  describe '#initialize' do
    it 'initializes a Decorator object with a nameable object' do
      expect(decorator.nameable).to eq(nameable)
    end
  end

  describe '#correct_name' do
    it 'delegates the correct_name method to the nameable object' do
      allow(nameable).to receive(:correct_name).and_return('Bob')
      expect(decorator.correct_name).to eq('Bob')
    end
  end
end
