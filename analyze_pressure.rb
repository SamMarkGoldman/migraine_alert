require 'pry'
require 'date'
require_relative 'config'
require_relative 'weather'
require_relative 'delivery'

# must be below 30
# look at all points between 0.75 and 2 days, if any of them produce slope below -0.3
# look at all points between 2 and 3 days, if any of them produce slope below -0.2

window = Weather::Window.new
window.load_file

current = Weather::Reading.fetch_current
window.add_reading(current)
result = window.analyze

Delivery::Scheduler.new(result).schedule if result
window.save_file