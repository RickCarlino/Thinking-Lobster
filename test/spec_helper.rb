require 'test/unit'
require 'mongo'
require 'mongoid'

#Make a simple document for test cases.
require_relative '../lib/thinking_lobster.rb'
Mongoid.load!('test/database.yml', :test)

class Item
  include Mongoid::Document
  include ThinkingLobster
end