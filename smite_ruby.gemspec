$:.push File.expand_path("../lib", __FILE__)
Gem::Specification.new do |s|
  s.name          = 'smite_ruby'
  s.version       = '1.4.9'
  s.date          = '2016-02-18'
  s.summary       = 'Ruby Smite API'
  s.description   = 'Ruby Client for consuming the Smite API'
  s.authors       = ['NcUltimate']
  s.email         = 'jmklemen@gmail.com'
  s.files         = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.license       = 'MIT'
  s.homepage      = 'https://rubygems.org/gems/smite_ruby'

  s.add_runtime_dependency 'httparty'
  s.add_runtime_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
end