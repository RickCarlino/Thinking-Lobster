require 'mongoid'
require 'active_support'

module ThinkingLobster

#TODO:
  # [] Move all fixed numbers into user definable vars. eg. default review_due_at, intervals, etc
  # [x] Make protected members protected again
  # [] Remove active support dependecy in favor of manual caluclations for .days, .hours, etc
  # [] Consider implementing a time_since_review method to replace time_since_due
  # [] Write documentation
  # [] Github pages for sdoc documentation
  # [] wiki pages for use cases, design philosophy.

  # Includes a set of fields and support methods into the base class. Mongoid
  # must be included in the base class.
  #
  # ==== Examples
  #   class FlashCard
  #     include Mongoid::Document
  #     include ThinkingLobster
  #     field :question
  #     field :answer
  #   end
  def self.included(collection)
    #Make all of the hardcoded 2's a user defined variable.
    collection.send :field, :times_reviewed,  type: Integer, default: 0
    collection.send :field, :winning_streak,  type: Integer, default: 0
    collection.send :field, :losing_streak,   type: Integer, default: 0
    collection.send :field, :review_due_at,   type: Time,default: ->{Time.now}
    collection.send :field, :previous_review, type: Time
  end

  # Marks the item correct and increases the item's review intervals 
  # accordingly. Takes no action if review takes place before the
  # scheduled review time.
  #
  # * <tt>current_time</tt> - Time object by which review times are set. This 
  # parameter is typically left to its default value but may be useful for 
  # testing or special use cases.
  #
  # Returns an instance of the base class
  def mark_correct!(current_time = Time.now)
    return self if self.too_soon?(current_time)
    increment_wins
    if time_since_due(current_time) < 36.hours
      new_item_correct(current_time)
    else
      old_item_correct(current_time)
    end
    self.save
    self
  end

  # Marks the item incorrect and shortens the review interval.
  #
  # * <tt>current_time</tt> - Time object by which review times are set. 
  # Defaults to Time.now This parameter is typically left to its default
  # value but may be useful for 
  # testing or special use cases.
  #
  # Returns an instance of the base class.
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

  # Indicates quantity of time since the item became ready for a review. This
  # method is under consideration for deprecation in favor of a method which 
  # returns time since the last review.
  #
  # * <tt>current_time</tt> - Time object which defaults to +Time.now+. This
  # is the time by which the method compares.
  #
  # Returns an Integer
  def time_since_due(current_time = Time.now)
    current_time - self.review_due_at
  end

  # Indicates if a review would be 'premature' at the indicated time.
  #
  # * <tt>current_time</tt> - Time object which defaults to +Time.now+. This
  # is the time by which the method compares.
  #
  # Returns a Boolean
  def too_soon?(current_time = Time.now)
    too_soon = current_time < self.review_due_at
    if too_soon then true else false end
  end

  def previous_review?
    self.previous_review != nil
  end

  protected

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

  def set_previous_review!(current_time = Time.now)
    if self.previous_review?
      self.previous_review = self.review_due_at
    else
      #For items that don't have a previous review time.
      self.previous_review = current_time
    end
  end

end
