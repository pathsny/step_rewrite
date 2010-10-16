# -*- encoding: utf-8 -*-
require File.expand_path("../lib/step_rewrite/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "step_rewrite"
  s.version     = StepRewrite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vishnu S Iyengar"]
  s.email       = %q{pathsny@gmail.com}
  s.homepage    = "http://rubygems.org/gems/step_rewrite"
  s.summary     = %q{A Gem to Rewrite Ruby code from a special syntax into an evented IO form}
  s.description = %q{A Gem to Rewrite Ruby code from a special syntax into an evented IO form}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "step_rewrite"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.6"
  s.add_development_dependency "rspec", "~> 2.0.0.beta.22"
  s.add_dependency "sexp_processor", "~> 3.0.5"
  s.add_dependency 'ruby2ruby', "~> 1.2.5"
  s.add_dependency 'ParseTree', "~> 3.0.6"


  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
