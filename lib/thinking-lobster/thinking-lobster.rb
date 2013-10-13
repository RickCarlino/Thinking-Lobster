require 'mongoid'
require 'active_support'
module ThinkingLobster

  def self.included(collection)
    # collection.send :field, :current_interval, type: Integer, default: 4
    collection.send :field, :times_reviewed, type: Integer, default: 0
    collection.send :field, :winning_streak, type: Integer, default: 0
    collection.send :field, :losing_streak, type: Integer, default: 0
    collection.send :field, :review_time, type: Time, default: ->{Time.now + 4.hours}
  end

  # def mark_correct
  #   current_interval = (Time.now - self.review_time).to_hours
  #   if current_interval < 32
  #     self.review_time= Time.now + (current_interval * 2).hours
  #   else
  #      *= 1.4
  #   end
  #   self.next_review = TimeDate.now + current_interval.hours
  #   self.winning_streak += 1
  #   times_reviewed += 1
  #   return self
  # end

  # def mark_incorrect
  #   self.current_interval = 4
  #   self.streak = 0
  #   times_reviewed += 1
  #   self.next_review = TimeDate.now
  #   return self
  # end

end
