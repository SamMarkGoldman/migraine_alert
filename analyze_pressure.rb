require 'pry'
require 'date'
require_relative 'weather'
require_relative 'config'

# must be below 30
# look at all points between 0.75 and 2 days, if any of them produce slope below -0.3
# look at all points between 2 and 3 days, if any of them produce slope below -0.2

pr = Weather::CurrentPressure.fetch
binding.pry
puts 'asda'