require 'net/http'
require 'json'

module Weather
  class Reading
    attr_reader :time, :pressure

    URI = URI("http://api.wunderground.com/api/#{::Config::Weather::API_KEY}/conditions/q/#{::Config::Weather::STATE}/#{::Config::Weather::CITY}.json")

    def self.from_json(json)
      h = JSON.parse(json)
      self.new(epoch: h['time'], pressure: h['pressure'])
    end

    def to_json(options = {})
       JSON.pretty_generate({time: @time.strftime('%s'), pressure: @pressure}, options)
    end

    def self.fetch_current
      json = Net::HTTP.get(URI)
      response = JSON.parse(json)

      epoch = response['current_observation']['observation_epoch']
      pressure = response['current_observation']['pressure_in']
      self.new(epoch: epoch, pressure: pressure)
    end

    def initialize(epoch:, pressure:)
      @time = Time.at(epoch.to_i)
      @pressure = pressure.to_f
    end

    def hours_diff(other)
      (self.time - other.time) / 3600.0
    end

    def pressure_diff(other)
      self.pressure - other.pressure
    end

    def slope(other)
      pressure_diff(other) / hours_diff(other)
    end
  end
end
