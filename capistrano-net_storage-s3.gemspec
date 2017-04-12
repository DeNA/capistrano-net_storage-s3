# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/net_storage/s3/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-net_storage-s3'
  spec.version       = Capistrano::NetStorage::S3::VERSION
  spec.authors       = ['progrhyme']

  spec.summary       = 'Plugin of capistrano-net_storage for Amazon S3'
  spec.description   = 'A transport plugin of capistrano-net_storage to deploy application via Amazon S3.'
  spec.homepage      = 'https://github.com/DeNADev/capistrano-net_storage-s3'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency 'capistrano-net_storage'
  spec.add_runtime_dependency 'retryable'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
