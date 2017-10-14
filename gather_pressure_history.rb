require 'pry'
require 'date'
require_relative 'weather'
require_relative 'config'

today = Time.new.to_date
date = Config::Weather::START_DATE

# while date < today
#   Weather::HistoricPressure.new(date)
#   date = date.next_day
# end
pressure = Weather::HistoricPressure.new(date)
o = pressure.fetch
binding.pry
puts 'asda'
