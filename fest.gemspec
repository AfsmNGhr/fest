Gem::Specification.new do |s|
  s.name = "fest"
  s.version = "0.0.3"
  s.authors = ["Alexsey Ermolaev"]
  s.email = %q{afay.zangetsu@gmail.com}
  s.homepage = %q{https://github.com/AfsmNGhr/fest}
  s.description = %q{Ruby wrapper for festival scripts}
  s.summary = %q{Ruby wrapper for festival speech engine}
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.requirements << 'Festival speech engine'
end
