require 'pry'
require 'date'
require 'json'
require_relative 'weather'
require_relative 'config'

today = Time.new.to_date
date = Config::Weather::START_DATE

file_string = File.read(Config::Weather::FILE_NAME)
file_string = file_string.empty? ? '[]' : file_string
data_collection = JSON.parse(file_string) 

request_count = 0
reqest_interval = 60.0 / Config::Weather::MAX_REQUESTS_MIN

while date < today || request_count >= Config::Weather::MAX_REQUESTS_DAY
  start_time = Time.new

  day_data = Weather::HistoricPressure.new(date).fetch
  data_collection += day_data
  File.write(Config::Weather::FILE_NAME, data_collection.to_json)
  date = date.next_day
  request_count += 1

  puts 'another'
  sleep(reqest_interval - (Time.new - start_time))
end
