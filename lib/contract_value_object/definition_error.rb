class ContractValueObject
  class DefinitionError < ArgumentError
    include Contracts

    ErrorMessage = Struct.new(:attribute, :message)
    attr_reader :error_messages

    Contract ArrayOf[ErrorMessage] => Any
    def initialize(error_messages)
      @error_messages = error_messages
      message_components = error_messages.each_with_index.map do |error, index|
        "#{index + 1}. `#{error.attribute}`: #{error.message}"
      end

      message = ['', *message_components].join("\n")
      super message
    end
  end
end
