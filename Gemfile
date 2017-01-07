source 'https://rubygems.org'

group :test do
  gem 'json_pure', '2.0.1' if RUBY_VERSION < '2.0'
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '>= 3.8'
  gem 'rspec-core', '< 3.2' if RUBY_VERSION < '1.9'
  gem 'rspec-puppet', git: 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'vagrant-wrapper'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
end
