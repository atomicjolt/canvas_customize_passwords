# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canvas_customize_passwords/version'

Gem::Specification.new do |spec|
  spec.name          = "canvas_customize_passwords"
  spec.version       = CanvasCustomizePasswords::Version
  spec.authors       = ["James Carbine"]
  spec.email         = ["james.carbine@atomicjolt.com"]

  spec.summary       = "Customizes Canvas password requirements"
  spec.description   = "Customizes Canvas password requirements"
  spec.homepage      = "https://atomicjolt.com"

  spec.files = Dir["{app,lib}/**/*"]
end
