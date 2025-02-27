# Gem specification file (aws_logs.gemspec)
Gem::Specification.new do |spec|
  spec.name          = "awslogs"
  spec.version       = "0.1.0"
  spec.authors       = ["@mandelbro"]
  spec.email         = ["chris@montesmakes.co"]

  spec.summary       = %q{Toolkit for querying AWS Service logs.}
  spec.description   = %q{Toolkit for querying AWS Service logs.}
  spec.homepage      = "https://github.com/mandelbro/awslogs"
  spec.license       = "MIT"

  # Specify which files should be included in the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|lib)/}) } }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Optional dependencies (add any you need)
  # spec.add_dependency "some_other_gem", "~> version"
  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "aws-sdk-s3", "~> 1.182"
  spec.add_dependency "logger", "~> 1.6"

  # Development dependencies (for testing, etc.)
  spec.add_development_dependency "bundler", "~> 2.6"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  # spec.add_development_dependency "dotenv", "~> 3.1.7"
  spec.add_development_dependency "simplecov", "~> 0.22"
end
