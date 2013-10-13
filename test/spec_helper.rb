require 'test/unit'
require 'mongo'
require 'mongoid'
require 'pry'
require_relative '../lib/thinking-lobster/thinking-lobster.rb'

# Setup the database
Mongoid.load!("test/database.yml", :test)
