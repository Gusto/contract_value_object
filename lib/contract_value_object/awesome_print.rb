if defined?(::AwesomePrint)
  module ::AwesomePrint::ContractValueObject
    def self.included(base)
      base.send :alias_method, :cast_without_cvo, :cast
      base.send :alias_method, :cast, :cast_with_cvo
    end

    def cast_with_cvo(object, type)
      cast = cast_without_cvo(object, type)
      if (defined?(::ContractValueObject)) && (object.is_a?(::ContractValueObject))
        cast = :contract_value_object
      end
      cast
    end

    def awesome_contract_value_object(object)
      "#{object.class} #{awesome_hash(object.to_h)}"
    end
  end

  AwesomePrint::Formatter.send(:include, AwesomePrint::ContractValueObject)
end
