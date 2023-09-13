require 'rspec'
require_relative '../classes/capitalize_decorator'
require_relative '../classes/decorator'

describe CapitalizeDecorator do
  let(:base_decorator) { double('BaseDecorator') }
  let(:capitalize_decorator) { CapitalizeDecorator.new(base_decorator) }

  describe '#correct_name' do
    it 'capitalizes the correct name returned by the base decorator' do
      allow(base_decorator).to receive(:correct_name).and_return('bob')
      expect(capitalize_decorator.correct_name).to eq('Bob')
    end
  end
end
