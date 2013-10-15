require 'spec_helper'

#Make a simple document for test cases.
class Item
  include Mongoid::Document
  include ThinkingLobster
end


class ThinkingLobsterTest < Test::Unit::TestCase
 
  def setup
    @current_time = Time.now
    @item = Item.create(review_due_at: (@current_time - 2.hours))
  end

  def teardown
    Item.destroy_all
  end

  def test_times_reviewed
    assert_respond_to(@item, :times_reviewed)
    assert_instance_of(Fixnum, @item.times_reviewed)
  end

  def test_winning_streak
    assert_respond_to(@item, :winning_streak)
    assert_instance_of(Fixnum, @item.winning_streak)
  end

  def test_losing_streak
    assert_respond_to(@item, :losing_streak)
    assert_instance_of(Fixnum, @item.losing_streak)
  end

  def test_review_due_at
    assert_respond_to(@item, :review_due_at)
    assert_instance_of(Time, @item.review_due_at)
  end

  def test_new_correct
    @item.mark_correct!(@current_time)
    correct_review_time = @current_time + 4.hours
    assert_equal(1, @item.winning_streak)
    assert_equal(0, @item.losing_streak)
    assert_equal(correct_review_time, @item.review_due_at)
    assert_equal(@item.current_interval, 4.hours)
  end

  def test_new_incorrect
    @item.mark_incorrect!(@current_time)
    assert_equal(0, @item.winning_streak)
    assert_equal(1, @item.losing_streak)
    assert_equal(@current_time, @item.review_due_at)
    assert_equal(@item.current_interval, 2.hours)
  end

end
