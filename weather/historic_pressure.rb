require 'net/http'

############################################################################################################
# This file is basically deprecated because wunderground turned off their API.
# new APIs to try:
# https://darksky.net/dev (used for current pressure)
# https://openweathermap.org/api (has historic too, but current for free is only updated every other hour)
############################################################################################################

module Weather
  class HistoricPressure
    def initialize(date)
      @date = date
    end

    def fetch
      json = Net::HTTP.get(uri)

      response = JSON.parse(json)
      response['history']['observations'].map do |measurement|
        {
          time: date_string(measurement['date']),
          temp: measurement['tempi'],
          wind: measurement['wspdi'],
          pressure: measurement['pressurei']
        }
      end
    end

    def date_string(d)
      "#{d['year']}#{d['mon']}#{d['mday']}#{d['hour']}#{d['min']}"
    end

    def uri
      URI("http://api.wunderground.com/api/#{Config::Weather::API_KEY}/history_#{@date.strftime('%Y%m%d')}/q/#{Config::Weather::STATE}/#{Config::Weather::CITY}.json")
    end
  end
end