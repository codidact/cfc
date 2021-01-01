require_relative 'lib/cfc/version'

Gem::Specification.new do |s|
  s.name          = 'cfc'
  s.version       = CFC::VERSION
  s.licenses      = ['MIT']
  s.summary       = 'Simple API library for interacting with the Cloudflare API.'
  s.description   = 'Simple API library for interacting with the Cloudflare API. See GitHub for usage details: ' \
                    'https://github.com/codidact/cfc'
  s.authors       = ['The Codidact Foundation']
  s.email         = 'gems@codidact.org'
  s.homepage      = 'https://github.com/codidact/cfc'
  s.files         = Dir['{lib}/**/*', 'LICENSE', 'README.md']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.4.0'
end
