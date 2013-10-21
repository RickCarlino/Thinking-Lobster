require 'spec_helper'

class LongTermReviewTest < Test::Unit::TestCase

  def setup
    @current_time  = Time.now
    @item          = Item.create(review_due_at: @current_time)
    @current_time += 40.hours
  end

  def teardown
    Item.destroy_all
  end

  def test_old_item_correct
    @item.mark_correct!(@current_time)
    assert_equal(1, @item.winning_streak)
    assert_equal(0, @item.losing_streak)
    expected_review_time = (@current_time + 50.hours).to_i
    actual_review_time   = (@item.review_due_at).to_i
    assert_equal(expected_review_time, actual_review_time)
  end

  def test_old_item_incorrect
    @item.mark_incorrect!(@current_time)
    assert_equal(0, @item.winning_streak)
    assert_equal(1, @item.losing_streak)
    expected_review_time = (@current_time + 10.hours).to_i
    actual_review_time   = (@item.review_due_at).to_i
  end

end
