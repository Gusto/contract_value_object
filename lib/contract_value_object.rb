require 'contracts'
require 'contract_value_object/definition_error'
require 'contract_value_object/error_formatter'

class ContractValueObject
  include Contracts

  class << self
    Contract Maybe[HashOf[Symbol, Any]] => HashOf[Symbol, Any]
    def attributes(attributes = nil)
      if attributes.nil?
        return @attributes if instance_variable_defined?(:@attributes)
        raise ArgumentError, 'Calling for attributes without having defined them.'
      end

      attr_accessor(*attributes.keys)
      attr_writers = attributes.keys.map { |attribute| :"#{attribute}=" }
      private *attr_writers

      @attributes = attributes
    end

    Contract Maybe[HashOf[Symbol, Any]] => HashOf[Symbol, Any]
    def defaults(defaults = nil)
      return @defaults ||= {} if defaults.nil?

      unexpected_defaults = defaults.keys - attributes.keys
      unless unexpected_defaults.empty?
        raise ArgumentError, "Unexpected defaults are set: #{unexpected_defaults.map(&:to_s).join(', ')}"
      end

      non_optional = defaults.select do |attribute, _|
        !attributes.fetch(attribute).is_a?(Contracts::Optional)
      end
      raise ArgumentError, "Unexpected non-optional defaults: #{non_optional.keys.join(', ')}" unless non_optional.empty?

      @defaults = defaults
    end

    attr_writer :error_presenter

    Contract RespondTo[:contract_failure, :missing, :unexpected]
    def error_presenter
      @error_presenter ||= self::ErrorFormatter.new
    end
  end

  Contract HashOf[Symbol, Any] => Any
  def initialize(**attributes)
    error_presenter = self.class.error_presenter
    class_attributes = self.class.attributes
    defaults = self.class.defaults
    error_message_class = DefinitionError::ErrorMessage

    # determine attributes that were not passed in but should have been
    missing_attributes = class_attributes.keys - attributes.keys - defaults.keys
    missing_attribute_errors = missing_attributes.flat_map do |attribute|
      next([]) if class_attributes[attribute].is_a?(Contracts::Optional)
      error_message_class.new(attribute, error_presenter.missing(attribute, class_attributes.fetch(attribute)))
    end

    # determine extraneous attributes that should not have been passed in
    unexpected_attributes = attributes.keys - class_attributes.keys
    unexpected_attribute_errors = unexpected_attributes.map do |attribute|
      error_message_class.new(attribute, error_presenter.unexpected(attribute))
    end

    # set attributes on the object and raise if they do not obey the contract
    setter_errors = defaults.merge(attributes).flat_map do |attribute, value|
      next([]) if unexpected_attributes.include?(attribute)

      begin
        contract = class_attributes.fetch(attribute)
        contract.within_opt_hash! if contract.is_a?(Contracts::Optional)
        # begin support customized setter
        send("#{attribute}=", value)
        set_value = instance_variable_get("@#{attribute}")
        # end support for customized setter
        if Contract.valid?(set_value, contract)
          []
        else
          raise ArgumentError, error_presenter.contract_failure(attribute, set_value, contract)
        end
      rescue self.class::DefinitionError => error
        error_message_class.new(attribute, error.message.gsub("\n", "\n\t"))
      rescue StandardError => error
        error_message_class.new(attribute, error.message)
      end
    end

    errors = missing_attribute_errors + unexpected_attribute_errors + setter_errors
    return if errors.empty?

    raise DefinitionError, errors
  end

  def to_h
    key_value_pairs = self.class.attributes.map do |attribute, _type|
      [attribute, public_send(attribute)]
    end

    key_value_pairs.to_h
  end

  # treating contract value objects with the same values as the same object for hashes and sets
  def hash
    to_h.hash
  end

  def ==(other)
    return super(other) unless self.class == other.class

    self.class.attributes.all? do |attribute, _type|
      public_send(attribute) == other.public_send(attribute)
    end
  end

  alias_method :eql?, :==

  def inspect
    "#{self.class} #{to_h.inspect}"
  end

  def ai(options = {})
    "#{self.class} #{to_h.ai(options)}"
  end
end
