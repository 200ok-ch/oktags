require_relative 'lib/ok/version'

Gem::Specification.new do |spec|
  spec.name          = "oktags"
  spec.version       = OK::Tags::VERSION
  spec.authors       = ["Alain M. Lafon"]
  spec.email         = ["info@200ok.ch"]
  spec.licenses      = "AGPL-3.0-or-later"

  spec.summary       = %q{Manage tags on plain old files.}
  spec.description   = %q{oktags helps you organize your files by managing tags on them. It works by adding/removing at the end of the filename. Given a file 'cat.jpg', when adding the tags 'tag1' and 'tag2', the filename will become 'cat--[tag1,tag2].jpg'. The implementation is OS-agnostic, so it should work on Linux, macOS and Windows. }
  spec.homepage      = "https://200ok.ch"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/200ok-ch/oktags"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables = ['oktags']
  spec.require_paths = ["lib"]
end
