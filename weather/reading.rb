require 'net/http'
require 'json'

module Weather
  class Reading
    URI = URI("http://api.wunderground.com/api/#{Config::Weather::API_KEY}/conditions/q/#{Config::Weather::STATE}/#{Config::Weather::CITY}.json")

    def self.from_json(json)
      h = JSON.parse(json)
      self.new(epoch: h['time'], pressure: h['pressure'])
    end

    def to_json
      {time: timet.strftime('%s'), pressure: pressure}
    end

    def self.fetch_current
      json = Net::HTTP.get(uri)
      response = JSON.parse(json)

      epoch = response['current_observation']['observation_epoch']
      pressure = response['current_observation']['pressure_in']
      self.new(epoch: epoch, pressure: pressure)
    end

    def initialize(epoch:, pressure:)
      @time = Time.at(epoch.to_i)
      @pressure = pressure
    end
  end
end
