require 'net/http'
require 'json'
require 'time'

module Weather
  class Reading
    SECONDS_IN_DAY = (24 * 60 * 60.0)
    HPA_IN_INHG = 33.863886666667

    attr_reader :time, :pressure

    URI = URI("https://api.darksky.net/forecast/#{::Config::Weather::API_KEY}/#{::Config::Weather::LAT_LON}")

    def self.from_hash(h)
      self.new(epoch: h['time'], pressure: h['pressure'])
    end

    def to_json(options = {})
       JSON.pretty_generate({time: @time.strftime('%s'), pressure: @pressure}, options)
    end

    def self.fetch_current
      json = Net::HTTP.get(URI)
      response = JSON.parse(json)

      epoch = response['currently']['time']
      pressure = response['currently']['pressure'] / HPA_IN_INHG
      self.new(epoch: epoch, pressure: pressure)
    end

    @@mock_position = 0

    def self.fetch_mock
      pressure = -1
      while pressure < 0
        mock = self.mock_data[@@mock_position]
        time = Time.parse(mock['time']).strftime('%s')
        pressure = mock['pressure'].to_f
        @@mock_position += 1
      end
      self.new(epoch: time, pressure: pressure)
    end

    def self.mock_data
      @@mock_data ||= JSON.parse(File.read('historic_data/history_new_york.json'))
    end

    def initialize(epoch:, pressure:)
      @time = Time.at(epoch.to_i)
      @pressure = pressure.to_f
    end

    def days_diff(other)
      (self.time - other.time) / SECONDS_IN_DAY
    end

    def pressure_diff(other)
      self.pressure - other.pressure
    end

    def slope(other)
      pressure_diff(other) / days_diff(other)
    end

    def to_s
      "Time: #{time}, Pressure: #{pressure}"
    end
  end
end
