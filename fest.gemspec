Gem::Specification.new do |gem|
  gem.name = 'fest'
  gem.version = '1.1.10'
  gem.authors = 'Alexsey Ermolaev'
  gem.email = 'afay.zangetsu@gmail.com'
  gem.homepage = 'https://github.com/AfsmNGhr/fest'
  gem.description = 'Ruby wrapper for festival scripts'
  gem.summary = 'Ruby wrapper for festival speech engine'
  gem.license = 'MIT'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '3.2.0'

  gem.files = `git ls-files`.split("\n")
  gem.require_paths = ['lib']
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})

  gem.extra_rdoc_files = ['MIT-license.org', 'README.md']
  gem.requirements = ['*nix* or OS X', 'Pulseaudio sound server',
                      'Festival snpeech engine', 'xbacklight']
end
