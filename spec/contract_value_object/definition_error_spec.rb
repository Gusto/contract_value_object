require 'spec_helper'

RSpec.describe ContractValueObject::DefinitionError do
  describe '::new' do
    subject { described_class.new(error_messages) }

    let(:error_messages) { [] }

    it do
      is_expected.to have_attributes(
        error_messages: error_messages,
        message: ''
      )
    end

    context 'when there are error messages' do
      let(:error_messages) { [error_message] }
      let(:error_message) { described_class::ErrorMessage.new(attribute, message) }
      let(:attribute) { :key }
      let(:message) { 'This is the end' }

      it do
        is_expected.to have_attributes(
          error_messages: error_messages,
          message: <<~MSG.gsub(/\n$/, '')
            
            1. `key`: This is the end
          MSG
        )
      end
    end
  end
end
