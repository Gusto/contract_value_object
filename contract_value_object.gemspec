lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'contract_value_object/version'

Gem::Specification.new do |spec|
  spec.name          = 'contract_value_object'
  spec.version       = ContractValueObject::VERSION
  spec.authors       = ['Kirill Klimuk']
  spec.email         = ['kklimuk@gmail.com']

  spec.summary       = %q{Validate that your objects have the right inputs.}
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://gemstash.zp-int.com/private'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'contracts'

  spec.add_development_dependency 'bundler', '~> 1.17.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'awesome_print'
end
