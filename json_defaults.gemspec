lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_defaults/version'

Gem::Specification.new do |spec|
  spec.name          = 'json_defaults'
  spec.version       = JsonDefaults::VERSION
  spec.authors       = ['DenDos']
  spec.email         = ['cotoha92@gmail.com']

  spec.summary       = 'Create default structure for jsonb field'
  spec.description   = 'https://github.com/DenDos/json-defaults'
  spec.homepage      = ''

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activerecord', '~> 4.2'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pg', '~> 0.21.0'
  spec.add_development_dependency 'rake', '~> 13.0.1'
  spec.add_development_dependency 'rspec'
end
