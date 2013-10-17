require 'spec_helper'

class TestFirstReview < Test::Unit::TestCase
 
  def setup
    @current_time = Time.now
    @item         = Item.create
  end

  def teardown
    Item.destroy_all
  end

  def test_new_correct
    old_review_time = @item.review_due_at
    @item.mark_correct!(@current_time)
    correct_review_time = @current_time + 2.hours
    assert_equal(1, @item.winning_streak)
    assert_equal(0, @item.losing_streak)
    assert_equal(correct_review_time, @item.review_due_at)
    assert_equal(old_review_time.to_i, @item.previous_review.to_i)
  end

  def test_new_incorrect
    @item.mark_incorrect!(@current_time)
    assert_equal(0, @item.winning_streak)
    assert_equal(1, @item.losing_streak)
    assert_equal(@current_time, @item.review_due_at)
  end

end
