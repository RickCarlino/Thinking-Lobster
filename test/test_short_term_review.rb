require 'spec_helper'

class ShortTermReviewTest < Test::Unit::TestCase

  def setup
    @current_time = Time.now
    @item         = Item.create(review_due_at: @current_time)
    @item.mark_correct!(@current_time)

  end

  def teardown
    Item.destroy_all
  end

  def test_short_term_correct
    correct_review_time = @current_time + 2.hours
    assert_equal(correct_review_time, @item.review_due_at)
    @item.mark_correct!(@current_time + 2.5.hours)
    assert_equal(2, @item.winning_streak)
    assert_equal(0, @item.losing_streak)
    assert_equal(2, @item.times_reviewed)
    assert_equal(correct_review_time, @item.previous_review)
  end

  def test_short_term_incorrect
    @item.mark_incorrect!(@current_time)
    assert_equal(2, @item.times_reviewed)
    assert_equal(0, @item.winning_streak)
    assert_equal(1, @item.losing_streak)
    assert_equal(@current_time, @item.review_due_at)
  end

end
