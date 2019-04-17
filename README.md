# Contract Value Object

Contract value object are designed for two purposes:
1. To create objects that act like values (in the same way that two ruby `Date` objects are the same if their year, month, and date are the same)
2. That values can only be created with correct values. That means that no invalid value types should be able to exist.

It's implemented on top of the [Contracts gem](http://egonschiele.github.io/contracts.ruby/) that allows us to define the accepted values for each attribute.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'contract_value_object'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install contract_value_object

## Usage

There are two main methods that are exposed when constructing a Contract Value Object:
- `attributes` - allows you to define all of the attributes that you expect to be passed in
  - input: hash, where the keys are the names of the attributes and the keys are the contract that must be met
- `defaults` - allows you to define the default values that will be set if a value will not be passed in. All of these should explicitly `Optional` contracts in the attributes.
  - input: hash, where the keys are the attributes that should be default and the keys are the default values

Example usage:

```ruby
class Truck < ContractValueObject
  class Wheel < ContractValueObject
    attributes(
      size: Optional[Enum[:xs, :s, :m, :l, :xl]],
    )

    defaults(
      size: :m,
    )
  end

  attributes(
    wheels: ArrayOf[Wheel],
    color: Enum[:red, :white, :blue],
    model: String,
  )
end

Truck.new(
  wheels: [Truck::Wheel.new, Truck::Wheel.new, Truck::Wheel.new, Truck::Wheel.new],
  color: :red,
  model: 'Ford F150',
)
```

## Development

Run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local mcontract_value_objectine, run `bundle exec rake install`. 
To release a new version:
1. `rake release`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Gusto/. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Contract Value Object project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Gusto/contract_value_object/blob/master/CODE_OF_CONDUCT.md).
