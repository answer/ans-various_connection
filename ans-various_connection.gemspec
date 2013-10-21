# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ans/various_connection/version'

Gem::Specification.new do |spec|
  spec.name          = "ans-various_connection"
  spec.version       = Ans::VariousConnection::VERSION
  spec.authors       = ["sakai shunsuke"]
  spec.email         = ["sakai@ans-web.co.jp"]
  spec.description   = %q{同じ構成の複数の DB からデータを取得するためのメソッドを提供する}
  spec.summary       = %q{複数の接続を扱うメソッドを提供する}
  spec.homepage      = "https://github.com/answer/ans-various_connection"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
