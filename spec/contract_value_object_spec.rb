require 'spec_helper'

RSpec.describe ContractValueObject do
  describe 'definition' do
    subject { klass }

    context 'when calling attributes without having defined them' do
      let(:klass) { Class.new(described_class) { attributes } }

      it do
        expect { subject }.to raise_error(ArgumentError, 'Calling for attributes without having defined them.')
      end
    end

    context 'when setting defaults that are not part of the attributes' do
      let(:klass) do
        Class.new(described_class) do
          attributes(elephant_seal: String)
          defaults(walrus: Contracts::Optional[String])
        end
      end

      it { expect { subject }.to raise_error(ArgumentError, 'Unexpected defaults are set: walrus') }
    end

    context 'when setting defaults that are not optionals' do
      let(:klass) do
        Class.new(described_class) do
          attributes(elephant_seal: String)
          defaults(elephant_seal: String)
        end
      end

      it { expect { subject }.to raise_error(ArgumentError, 'Unexpected non-optional defaults: elephant_seal') }
    end
  end

  describe '#initialize' do
    subject { klass.new(attributes) }

    let(:klass) do
      attribute_hash = definition
      defaults = default_definition
      Class.new(described_class) do
        attributes attribute_hash

        defaults defaults

        private

        def hi=(value)
          @hi = value.to_s
        end
      end
    end

    let(:definition) { { foo: Symbol } }
    let(:attributes) { { foo: :bar } }
    let(:default_definition) { {} }

    it { is_expected.to have_attributes(foo: :bar) }

    context 'when there is a non-default value setter' do
      let(:definition) { { hi: String } }
      let(:attributes) { { hi: :truck } }

      it 'uses the non-default setter' do
        is_expected.to have_attributes(hi: 'truck')
      end
    end

    context 'when the attribute is optional' do
      let(:definition) { { foo: Contracts::Optional[Symbol] } }

      it { is_expected.to have_attributes(foo: :bar) }
    end

    context 'when the expected attribute is not included' do
      let(:attributes) { {} }

      it do
        expect { subject }.to raise_error(ArgumentError, a_string_matching(/Missing attribute `foo`./))
      end

      context 'but it is optional' do
        let(:definition) { { foo: Contracts::Optional[Symbol] } }

        it { is_expected.to have_attributes(foo: nil) }
      end
    end

    context 'when the expected attribute does not match the type' do
      let(:attributes) { { foo: 1 } }

      it do
        expect { subject }.to raise_error(ArgumentError, a_string_matching(/Attribute `foo` does not conform to its contract/))
      end
    end

    context 'when there is an unexpected value' do
      let(:attributes) { { foo: :bar, baz: :taco } }

      it do
        expect { subject }.to raise_error(ArgumentError, a_string_matching(/Unexpected attribute `baz`/))
      end
    end

    context 'when there are defaults' do
      let(:default_definition) { { foo: :truck } }
      let(:definition) { { foo: Contracts::Optional[Symbol] } }

      context 'but the default is not passed in' do
        it { is_expected.to have_attributes(foo: :bar) }
      end

      context 'but the definition is not optional' do
        let(:definition) { { foo: Symbol } }

        it { expect { subject }.to raise_error(ArgumentError, 'Unexpected non-optional defaults: foo') }
      end

      context 'and the default is passed in' do
        let(:attributes) { {} }

        it { is_expected.to have_attributes(foo: :truck) }
      end
    end
  end

  describe '#==' do
    subject { klass.new(first_attributes) == other }

    let(:klass) do
      attribute_hash = definition
      Class.new(described_class) do
        attributes attribute_hash
      end
    end
    let(:definition) { { value: String } }

    let(:first_attributes) { { value: 'foo' } }

    let(:other) { klass.new(second_attributes) }
    let(:second_attributes) { first_attributes }

    it { is_expected.to be true }

    context 'when the attributes differ' do
      let(:second_attributes) { { value: 'no' } }

      it { is_expected.to be false }
    end

    context 'when the other is not the same class' do
      let(:other) { 'hello, world' }

      it { is_expected.to be false }
    end
  end

  describe '#to_h' do
    subject { klass.new(attributes).to_h }

    let(:klass) do
      attribute_hash = definition
      Class.new(described_class) do
        attributes attribute_hash
      end
    end
    let(:definition) { { value: String } }

    let(:attributes) { { value: 'Hello, world!' } }

    it { is_expected.to eq attributes }
  end

  describe '#hash' do
    subject { klass.new(attributes).hash }

    let(:klass) do
      attribute_hash = definition
      Class.new(described_class) do
        attributes attribute_hash
      end
    end
    let(:definition) { { key: Symbol, value: String } }

    let(:attributes) { { key: :name, value: 'Kirill Klimuk' } }

    it do
      expect(subject).to eq klass.new(attributes).hash
    end
  end
end
