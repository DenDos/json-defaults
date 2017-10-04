# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_defaults/version'

Gem::Specification.new do |spec|
  spec.name          = "json_defaults"
  spec.version       = JsonDefaults::VERSION
  spec.authors       = ["DenDos"]
  spec.email         = ["cotoha92@gmail.com"]

  spec.summary       = %q{Create default structure for jsonb field}
  spec.description   = %q{DEEEEEESSSSSCCCCRIRRRRRIIIIIPPPPTIOOOOONNNNN}
  spec.homepage      = ""

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "activerecord", "~> 4.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pg", "~> 0.18.4"
  spec.add_development_dependency "rspec"
end
