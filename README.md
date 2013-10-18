Thinking Lobster (Pre-release, as in, not yet released.)
===

A [spaced repetition algorithm](http://en.wikipedia.org/wiki/Spaced_repetition) written in Ruby for facts that use non-scaled responses. Highly influenced by the leitner method.

Goals
---
The goal of this repo is to

Examples
---

```ruby
class FlashCard
  include Mongoid::Document
  include ThinkingLobster
  field :question
  field :answer
end

q = FlashCard.create(question: 'First American President', answer: 'George Washington')

# Returns a ruby Time object...
q.review_time

# Marks the item correct and automatically schedules the next review time...
q.mark_correct!
# => #<FlashCard id: XYZ blahblahblah....

#Shrinks your interval when you answer the question incorrectly..
q.mark_incorrect!
# => #<FlashCard id: XYZ blahblahblah....


```

Installation
---

```
gem install thinking-lobster
```

or in your Gemfile with bundler via

```gem 'thinking-lobster'```

Testing
---

```rake test```

License
---

Licensed under the MIT License. See license.txt for more information.

Contributors
---

 * Brett Byler
 * Rick Carlino

Please add your name to this list if submitting a pull request.
