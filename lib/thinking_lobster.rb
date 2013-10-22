require 'mongoid'
require 'active_support/time'

module ThinkingLobster

#TODO:
  # [] Move all fixed numbers into user definable vars. eg. default review_due_at, intervals, etc
  # [x] Make protected members protected again
  # [x] Consider implementing a time_since_review method to replace time_since_due
  # [x] Write documentation
  # [x] Update the readme.md
  # [] Github pages for sdoc documentation
  # [] wiki pages for use cases, design philosophy.
  # [] Run a code coverage tool

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
    collection.send :field, :review_due_at,   type: Time,    default: ->{Time.now}
    collection.send :field, :previous_review, type: Time
    collection.send :include, Mongoid::Timestamps
  end

  # Stores various information about scheduling and other attributes that a developer might wish to tweak.
  #
  # * (Float) :cuttoff - A cutoff time (in seconds) that determines wether an item will be considered a short term (new) or long term (old) memory. Default value is `36.hours`. Therefore, by default, all items less than 36 hours old are considered short term.
  # * (Float) :first_interval - This is a float representing the time between the first and second interval of a new item (in seconds). Default value is `2.hours`.
  # * (Float) :new_positive_multiplier - The number by which a new item's interval is multiplied by when correctly reviewed. Default value is 2. Increasing this number will shorten the number of short term reviews. Must be greater than 1.0 . Be aware that there is no such thing as a new_negative_multiplier because incorrect new items get reset to the system default when incorrect.
  # * (Float) :old_positive_multiplier - The number by which an old item's interval is multiplied by when correctly reviewed. Default value is 1.25. Increasing this number will shorten the number of long term item reviews. Must be greater than 1.0 .
  # * (Float) :Penalty - The number by which an old item's interval is multiplied by when incorrectly answered. Can be any number equal to or greater than 0 or less than 1.0. Default value is 0.25 .

  mattr_accessor :config

  self.config = {
    cutoff:                  36.hours,
    first_interval:          2.hours,
    new_positive_multiplier: 2.0,
    old_positive_multiplier: 1.25,
    penalty:                 0.25
  }

  # Marks the item correct and increases the item's review intervals accordingly. Takes no action if review takes place before the scheduled review time.
  #
  # Example:
  #    flash_card = SomeDocument.new
  #    flash_card.mark_correct! # => #<SomeItem:0x123>
  #
  # Paramters:
  # * (Time) current_time - Time object by which review times are set. This parameter is almost always left to its default value (Time.now) but may be useful for testing or special use cases.
  #
  # Returns an instance of the base class
  def mark_correct!(current_time = Time.now)
    return self if self.too_soon?(current_time)
    increment_wins
    if time_since_review(current_time) < @@config[:cutoff]
      new_item_correct(current_time)
    else
      old_item_correct(current_time)
    end
    self.save
    self
  end

  # Marks the item incorrect and shortens the review interval.
  #
  # Example:
  #    flash_card = SomeDocument.new
  #    flash_card.mark_incorrect! # => #<SomeItem:0x123>
  #
  # Parameters:
  # * (Time) current_time - Time object by which review times are set. Defaults to Time.now This parameter is typically left to its default value but may be useful for testing or special use cases.
  #
  # Returns an instance of the base class.
  def mark_incorrect!(current_time = Time.now)
    increment_losses
    if time_since_review(current_time) < @@config[:cutoff]
      #the Review time after a new item's failure is Time.now
      new_item_incorrect(current_time)
    else
      old_item_incorrect(current_time)
    end
    self.save
    self
  end

  # Indicates quantity of time since the item became ready for a review. This method is under consideration for deprecation in favor of a method which returns time since the last review.
  #
  # Example: 
  #    flash_card = SomeDocument.new
  #    flash_card.time_since_due
  #    # => 144000
  #
  # * (Time) current_time - Time object which defaults to +Time.now+. This is the time by which the method compares.
  #
  # Returns an Integer
  def time_since_due(current_time = Time.now)
    current_time - self.review_due_at
  end

  # Indicates quantity of time since the item was last reviewed review. Be aware that this method is not the same thing as time_since_due().
  #
  # Example: 
  #    flash_card = SomeDocument.new
  #    flash_card.mark_correct!
  #    # Wait 5 seconds...
  #    flash_card.time_since_review
  #    # => 5.0
  #
  # * (Time) current_time - Time object which defaults to +Time.now+. This is the time by which the method compares. Usually there is no need to provide this parameter.
  #
  # Returns an Integer
  def time_since_review(current_time = Time.now)
    if self.previous_review?
      return current_time - self.previous_review
    else
      return current_time - self.created_at
    end
  end

  # Indicates if a review would be 'premature' at the indicated time, meaning that the application / user is trying to review a word too often.
  #
  # Example:
  #    flash_card = SomeDocument.new
  #    flash_card.mark_correct! 
  #    flash_card.too_soon? # In this example, we just finished the review. So it won't be due for a few more hours.
  #    # => false
  #
  # * (Time) current_time - Time object which defaults to Time.now. This is the time by which the method compares.
  #
  # Returns a Boolean
  def too_soon?(current_time = Time.now)
    too_soon = current_time < self.review_due_at
    if too_soon then true else false end
  end

  # Indicates if the item has a previous review set (which would indicate wether it is a newly added item).
  #
  # Example:
  #    flash_card = SomeDocument.new
  #    flash_card.previous_review?
  #    # => false
  #
  # No parameters
  #
  # Returns a Boolean
  def previous_review?
    self.previous_review != nil
  end
  # Resets all attributes related to spaced repetition. You still need to call save on the item to persist.
  def reset(current_time = Time.now)
    self.times_reviewed   = 0
    self.winning_streak   = 0
    self.losing_streak    = 0
    self.review_due_at    = current_time
    self.previous_review  = nil
  end

  protected

  def new_item_correct(current_time = Time.now)
    #Takes the interval between current_time and the time the item was due
    # And doubles that amount of time.
    if self.previous_review?
      self.set_previous_review!
      self.review_due_at += time_since_review(current_time) * @@config[:new_positive_multiplier]
    else
      self.set_previous_review!(current_time)
      self.review_due_at = current_time + @@config[:first_interval]
    end

  end

  def new_item_incorrect(current_time = Time.now)
    old_reviews = self.times_reviewed
    self.reset(current_time)
    self.increment_losses
    self.times_reviewed= old_reviews
    self.save
  end

  def old_item_correct(current_time = Time.now)
    hours_ago             = time_since_review(current_time)/60/60
    new_interval          = (hours_ago * @@config[:old_positive_multiplier]).hours
    self.review_due_at    = current_time + new_interval
  end

  def old_item_incorrect(current_time = Time.now)
    hours_ago             = time_since_review(current_time)/60/60
    new_interval          = (hours_ago * @@config[:penalty]).hours
    self.review_due_at    = current_time + new_interval
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
