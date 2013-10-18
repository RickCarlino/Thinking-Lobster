require 'spec_helper'

class LongTermReviewTest < Test::Unit::TestCase

  def setup
    @current_time = Time.now
    @new_item     = Item.create(review_due_at: @current_time)
    @current_time += 40.hours
  end

  def teardown
    Item.destroy_all
  end

  def test_old_item_correct
    @new_item.mark_correct!(@current_time)
    assert_equal(1, @new_item.winning_streak)
    assert_equal(0, @new_item.losing_streak)
    assert_equal(@current_time+50.hours, @new_item.review_due_at)
  end

  def test_old_item_incorrect
    @new_item.mark_incorrect!(@current_time)
    assert_equal(0, @new_item.winning_streak)
    assert_equal(1, @new_item.losing_streak)
    assert_equal(@current_time+10.hours, @new_item.review_due_at)
  end

end
