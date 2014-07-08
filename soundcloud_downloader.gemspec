# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soundcloud_downloader/version'

Gem::Specification.new do |spec|
  spec.name          = "soundcloud_downloader"
  spec.version       = SoundcloudDownloader::VERSION
  spec.authors       = ["Mico Piira"]
  spec.email         = ["mico.piira@yahoo.com"]
  spec.summary       = %q{SoundCloud downloader}
  spec.description   = %q{Downloads songs from SoundCloud to your 
computer as MP3 files}
  spec.homepage      = "https://gitlab.com/u/mixu"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "unirest", '~> 1.1'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end