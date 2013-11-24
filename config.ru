require 'rubygems'
require 'bundler/setup'
require File.expand_path '../boom.rb', __FILE__
log = File.new("sinatra.log", "a+")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application
