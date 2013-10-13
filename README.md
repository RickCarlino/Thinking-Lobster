Thinking Lobster (Pre-release)
===

A repo that will need to be renamed.

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

# Marks the item correct and automatically changes the review time...

```

Installation
---

```
gem install thinking-lobster
```

or with bundler via

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