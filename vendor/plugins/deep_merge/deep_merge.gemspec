# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "deep_merge"
  s.version     = '0.2.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Midgley", "Jonathan Weiss", "Lee Hambley"]
  s.email       = ["", "jw@innerewut.de", "lee.hambley@gmail.com"]
  s.homepage    = "http://github.com/leehambley/deep_merge"
  s.summary     = "Utility functions for deep-merging hashes"
  s.description = "Deep Merge is a simple set of utility functions for Hash to permit you to merge elements inside a hash together recursively."
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "deepmerge"
 
  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE README)
  s.require_path = 'lib'
end