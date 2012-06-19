require 'rubygems'
require 'mocha'
require 'rspec'
require 'rake/dsl_definition'

root_dir = File.expand_path(File.join(File.dirname(__FILE__), '../../'))
$: << './'
$: << File.join(root_dir, 'lib')
$: << File.join(root_dir, 'spec')

RSpec.configure do |config|
	config.mock_framework = :mocha
  	config.color_enabled = true
	config.tty = true
	config.formatter = :documentation
end

require 'simplecov'
SimpleCov.start do
	add_filter '/spec/'
end if ENV['COVERAGE']


