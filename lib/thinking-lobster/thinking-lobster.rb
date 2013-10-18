require 'mongoid'
require 'active_support'
module ThinkingLobster
require 'pry'

#Test Scenarios:
 # [x] Initial creation
 # []  reviewing an item too soon. (Gracefully do nothing- shouldn't be a design goal to handle this situation.)
 # [X]  New item incorrect
 # [X]  Old item incorrect
 # [x] New item correct
 # [X] Old item correct

#TODO:
  # [] Move all fixed numbers into user definable vars. eg. default review_due_at, intervals, etc
  # [] Make private members private again
  # [] Remove active support dependecy in favor of manual caluclations for .days, .hours, etc
  # [] Write documentation
  # [] Github pages for documentation
  # [] wiki pages for use cases, design philosophy.
  def self.included(collection)
    #Make all of the hardcoded 2's a user defined variable.
    collection.send :field, :times_reviewed, type: Integer, default: 0
    collection.send :field, :winning_streak, type: Integer, default: 0
    collection.send :field, :losing_streak, type: Integer, default: 0
    collection.send :field, :review_due_at, type: Time, default: ->{Time.now}
    collection.send :field, :previous_review, type: Time
  end

  def mark_correct!(current_time = Time.now)
    increment_wins
    if time_since_due(current_time) < 36.hours
      new_item_correct(current_time)
    else
      old_item_correct(current_time)
    end
    self.save
    self
  end

  def mark_incorrect!(current_time = Time.now)
    increment_losses
    if time_since_due(current_time) < 36.hours
      #Review time after early failure is Time.now
      new_item_incorrect(current_time)
    else
      old_item_incorrect(current_time)
    end
    self.save
    self
  end

  def new_item_correct(current_time)
    #Takes the interval between current_time and the time the item was due
    # And doubles that amount of time.
    if self.previous_review?
      self.set_previous_review!
      self.review_due_at += time_since_due(current_time) * 2
    else
      self.set_previous_review!(current_time)
      self.review_due_at = current_time + 2.hours
    end

  end

  def new_item_incorrect(current_time)
    self.review_due_at    = current_time
  end

  def old_item_correct(current_time)
    #TODO: Monkey patch class Time and DRY the following line into a helper
    hours_ago             = time_since_due(current_time)/60/60
    self.review_due_at    = current_time + (hours_ago * 1.25).hours
  end

  def old_item_incorrect(current_time)
    #TODO: Monkey patch class Time and DRY the following line into a helper
    hours_ago             = time_since_due(current_time)/60/60
    self.review_due_at    = current_time + (hours_ago * 0.25).hours
  end

  def increment_wins
    self.times_reviewed += 1
    self.winning_streak += 1
    self.losing_streak   = 0
  end

  def increment_losses
    self.times_reviewed += 1
    self.winning_streak  = 0
    self.losing_streak  += 1
  end

  def time_since_due(current_time = Time.now)
    current_time - self.review_due_at
  end

  def set_previous_review!(current_time = Time.now)
    if self.previous_review?
      self.previous_review = self.review_due_at
    else
      #For items that don't have a previous review time.
      self.previous_review = current_time
    end
  end

  def previous_review?
    self.previous_review != nil
  end
end
