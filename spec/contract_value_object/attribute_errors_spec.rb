require 'spec_helper'

RSpec.describe ContractValueObject::AttributeErrors do
  let(:presenter) { described_class.new }

  describe '#contract_failure' do
    subject { presenter.contract_failure(attribute, value, contract) }

    let(:attribute) { :key }
    let(:value) { :bar }
    let(:contract) { Symbol }

    it do
      is_expected.to eq <<~MSG.strip
        Attribute `key` does not conform to its contract.
        \tExpected: Symbol
        \tActual: Symbol (:bar)
      MSG
    end
  end

  describe '#missing' do
    subject { presenter.missing(attribute, contract) }

    let(:attribute) { :key }
    let(:contract) { Symbol }

    it do
      is_expected.to eq <<~MSG.strip
        Missing attribute `key`.
        \tExpected: Symbol
      MSG
    end
  end

  describe '#unexpected' do
    subject { presenter.unexpected(attribute) }

    let(:attribute) { :key }

    it { is_expected.to eq 'Unexpected attribute `key`.' }
  end
end
