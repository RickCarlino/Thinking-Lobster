require 'spec_helper'

class TestPrematureReview < Test::Unit::TestCase

  def setup
    @current_time = Time.now
    @item         = Item.create(
      review_due_at: @current_time + 10.hours,
      previous_review: @current_time + 8.hours
      )
  end

  def teardown
    Item.destroy_all
  end

  def test_premature_review
    @item.mark_correct!(@current_time)
    assert_equal(0, @item.winning_streak)
    assert_equal(0, @item.losing_streak)
    assert_equal(@current_time + 10.hours, @item.review_due_at)
    assert_equal(@current_time + 8.hours, @item.previous_review)
  end

end
