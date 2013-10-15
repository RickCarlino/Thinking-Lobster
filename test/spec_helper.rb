require 'test/unit'
require 'mongo'
require 'mongoid'
require 'pry'

#Make a simple document for test cases.
require_relative '../lib/thinking-lobster/thinking-lobster.rb'
Mongoid.load!("test/database.yml", :test)

class Item
  include Mongoid::Document
  include ThinkingLobster
end