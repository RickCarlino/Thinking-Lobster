Gem::Specification.new do |s|
  s.name        = 'thinking_lobster'
  s.version     = '1.0.0'
  s.summary     = 'A leitner based spaced repetition system algorithm for MongoDB.'
  s.date        = '2013-10-21'
  s.description = 'Automatically schedules review times for learning material stored in a mongoDB database by way of a spaced repetition algorithm. Resembles the Leitner Method.'
  s.authors     = ['Rick Carlino']
  s.homepage    = 'https://github.com/rickcarlino/Thinking-Lobster'
  s.files       = ['lib/thinking-lobster/thinking-lobster.rb']

  s.add_runtime_dependency 'bson_ext'
  s.add_runtime_dependency 'mongo'
  s.add_runtime_dependency 'mongoid'
  s.add_runtime_dependency 'active_support/time'

  s.add_development_dependency 'bson_ext'
  s.add_development_dependency 'mongo'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'mongoid'
  s.add_development_dependency 'sdoc'
end