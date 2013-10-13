require 'spec_helper'

#Make a simple document for test cases.
class Item
  include Mongoid::Document
  include ThinkingLobster
end


class ThinkingLobsterTest < Test::Unit::TestCase
 
  def setup
    binding.pry
  end
 
  def teardown
    Item.destroy_all
  end
 
  def test_simple
    assert_equal(4, (2+2) )
  end

end
