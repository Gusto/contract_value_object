class ContractValueObject
  class AttributeErrors
    include Contracts

    Contract Symbol, Any, Any => String
    def contract_failure(attribute, value, contract)
      [
        "Attribute `#{attribute}` does not conform to its contract.",
        "\tExpected: #{Contracts::Formatters::Expected.new(contract).contract}",
        "\tActual: #{value.class.name} (#{value.inspect})",
      ].join("\n")
    end

    Contract Symbol, Any => String
    def missing(attribute, contract)
      [
        "Missing attribute `#{attribute}`.",
        "\tExpected: #{Contracts::Formatters::Expected.new(contract).contract}",
      ].join("\n")
    end

    Contract Symbol => String
    def unexpected(attribute)
      "Unexpected attribute `#{attribute}`."
    end
  end
end
