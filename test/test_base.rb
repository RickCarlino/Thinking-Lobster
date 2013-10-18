require 'spec_helper'

class ThinkingLobsterBaseTest < Test::Unit::TestCase

  def setup
    @item         = Item.create
    @current_time = Time.now
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

  def test_time_since_due()
    desired_time_difference = @current_time - @item.review_due_at
    actual_time_difference  = @item.send(:time_since_due,@current_time)
    assert_equal(desired_time_difference, actual_time_difference)
  end

  def test_too_soon?
    assert_equal(false, @item.send(:too_soon?, @current_time + 4.hours))
    assert_equal(true,  @item.send(:too_soon?, @current_time - 4.hours))
  end

  def test_previous_review?
    assert_equal(false, @item.previous_review?)
    @item.update_attributes(previous_review: Time.now - 6.hours)
    assert_equal(true, @item.previous_review?)
  end
end
