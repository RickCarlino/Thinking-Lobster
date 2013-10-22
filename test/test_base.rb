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

  def test_time_since_due
    #TODO: Refactor this. This test is not testing exact values, rather it is making sure the values are within atleast 1 second of eachother.
    expected_value = (@current_time - @item.review_due_at).to_i
    actual_value   = (@item.time_since_due(@current_time)).to_i
    assert_equal(expected_value, actual_value)
  end

  def test_time_since_review
    #For items that don't have a previous_review...
    time_later     = @current_time + 5.hours
    actual_value   = @item.time_since_review(time_later).to_i
    expected_value = (time_later - @current_time).to_i
    assert_equal(expected_value, actual_value)

    #For items that do...
    @current_time = time_later
    time_later    = @current_time + 24.hours
    @item.mark_correct!(@current_time)
    actual_value   = @item.time_since_review(time_later)
    expected_value = time_later - @current_time
    assert_equal(expected_value, actual_value)
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
