require 'spec_helper'

class ThinkingLobsterBaseTest < Test::Unit::TestCase
 
  def setup
    @item         = Item.create
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

end
