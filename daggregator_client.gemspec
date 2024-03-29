# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "daggregator_client"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Michael"]
  s.date = "2012-05-08"
  s.description = "Provides model bindings for ActiveModel/ActiveRecord classes to automatically push attributes and relationships to daggregator as keys and flows"
  s.email = "kerinin@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "console.sh",
    "lib/daggregator.rb",
    "lib/daggregator/configuration.rb",
    "lib/daggregator/connection.rb",
    "lib/daggregator/model.rb",
    "lib/daggregator/model/class_methods.rb",
    "lib/daggregator/model/graph_builder.rb",
    "lib/daggregator/model/rest_api.rb",
    "lib/daggregator/model/serialization.rb",
    "spec/daggregator/configuration_spec.rb",
    "spec/daggregator/connection_spec.rb",
    "spec/daggregator/model/class_methods_spec.rb",
    "spec/daggregator/model/graph_builder_spec.rb",
    "spec/daggregator/model/serialization_spec.rb",
    "spec/daggregator/model_spec.rb",
    "spec/daggregator_spec.rb",
    "spec/spec_helper.rb",
    "spec/test_model.rb"
  ]
  s.homepage = "http://github.com/kerinin/daggregator_client"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Easily push data from to Daggregator"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<activemodel>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<activemodel>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<activemodel>, [">= 0"])
  end
end

