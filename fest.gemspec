Gem::Specification.new do |gem|
  gem.name = 'fest'
  gem.version = '1.3.10'
  gem.authors = 'Alexsey Ermolaev'
  gem.email = 'afay.zangetsu@gmail.com'
  gem.homepage = 'https://github.com/AfsmNGhr/fest'
  gem.description = 'Ruby wrapper for festival scripts'
  gem.summary = 'Ruby wrapper for festival speech engine'
  gem.license = 'MIT'

  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'rspec', '~> 3.3'

  gem.files = `git ls-files`.split("\n")
  gem.require_paths = ['lib', 'config']
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})

  gem.extra_rdoc_files = ['License.org', 'README.md']
  gem.requirements = ['*nix* or OS X', 'Pulseaudio sound server',
                      'Festival snpeech engine', 'xbacklight']
end
