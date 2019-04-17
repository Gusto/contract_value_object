# Contract Value Object

Validate that your objects have the right inputs.

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

Example usage:

Contract value object are designed for two purposes:
1. To create objects that act like values (in the same way that two ruby `Date` objects are the same if their year, month, and date are the same)
2. That values can only be created with correct types.

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
