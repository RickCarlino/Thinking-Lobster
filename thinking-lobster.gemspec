Gem::Specification.new do |s|
  s.name        = 'thinking-lobster'
  s.version     = '1.0.0.pre'
  s.summary     = 'A leitner based spaced repetition system algorithm for MongoDB.'
  s.date        = '2013-10-18'
  s.description = 'Spaced repetition is an educational practice which spaces review of learnable items to encourage permanent memorization. This gem brings automation to the process by providing MongoDB (Mongoid) users a way to quickly determine review intervals.'
  s.authors     = ['Rick Carlino']
  s.email       = ['rick@rickcarlino.com']
  s.homepage    = 'https://github.com/rickcarlino/Thinking-Lobster'
  s.files       = ['lib/thinking-lobster/thinking-lobster.rb']

  s.add_runtime_dependency 'bson_ext'
  s.add_runtime_dependency 'mongo'
  s.add_runtime_dependency 'mongoid'

  s.add_development_dependency 'bson_ext'
  s.add_development_dependency 'mongo'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'mongoid'
end