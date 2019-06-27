require 'awesome_print'
require 'spec_helper'

RSpec.describe ContractValueObject do
  let(:klass) { Class.new(ContractValueObject) { attributes(utencil: Contracts::Enum[:spoon, :chopsticks, :fork, :knife]) } }

  describe '#ai' do
    subject { klass.new(utencil: :spoon).ai }

    it { is_expected.to match(/#<Class:.*?> {\n\s+:utencil => :spoon\n}/) }
  end
end
