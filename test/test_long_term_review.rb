require 'spec_helper'

class LongTermReviewTest < Test::Unit::TestCase
 
  def setup
    @current_time = Time.now
    @new_item     = Item.create
    @old_item     = Item.create(review_due_at: @current_time + 37.hours)
  end

  def teardown
    Item.destroy_all
  end

  def test_old_item_incorrect
    @current_time = Time.now + 37.hours
    @new_item.mark_incorrect!(@current_time)
    assert_equal(0, @new_item.winning_streak)
    assert_equal(1, @new_item.losing_streak)
    assert_equal(@current_time, @new_item.review_due_at)
    assert_equal(@new_item.current_interval, 2.hours)
  end

end
