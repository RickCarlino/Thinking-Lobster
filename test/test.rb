require 'test/unit'
require 'mongo'
require 'mongoid'
require 'pry'
require_relative '../lib/thinking-lobster/thinking-lobster'

#Setup the databse..
Mongoid.load!('test/database.yml', :test)

#Make a simple document for test cases.
class Item
  include Mongoid::Document
  include ThinkingLobster
end


class ThinkingLobsterTest < Test::Unit::TestCase
 
  def setup
    @item = Item.create
  end

  def teardown
    Item.destroy_all
  end

  def test_times_reviewed
    assert_equal(@item.has_attribute?(:times_reviewed), true)
    assert_instance_of(Fixnum, @item.times_reviewed)
  end

  def test_winning_streak
    assert_equal(@item.has_attribute?(:winning_streak), true)
    assert_instance_of(Fixnum, @item.winning_streak)
  end

  def test_losing_streak
    assert_equal(@item.has_attribute?(:losing_streak), true)
    assert_instance_of(Fixnum, @item.losing_streak)
  end

  def test_review_time
    assert_equal(@item.has_attribute?(:review_time), true)
    assert_instance_of(Time, @item.review_time)
  end

end