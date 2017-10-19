require 'json'

module Weather
  class Window
    FILE_NAME = Config::Weather::Window::FILE_NAME
    RETENTION = Config::Weather::Window::RETENTION_HOURS
    LOW_HIGH_THRESHOLD = Config::Weather::Window::LOW_HIGH_THRESHOLD
    MIN_THRESHOLD = Config::Weather::Window::MIN_THRESHOLD
    LOW_SLOPE = Config::Weather::Window::LOW_SLOPE
    HIGH_SLOPE = Config::Weather::Window::HIGH_SLOPE

    def load_file
      @data = JSON.parse(file_content)
    end

    def file_content
      File.file?(FILE_NAME) ? File.read(FILE_NAME) : '[]'
    end

    def save_file
      File.write(FILE_NAME, @data.to_json)
    end

    def add_reading(reading)
      @current_reading = reading
      @data << reading
    end

    def analyze
      @data.dup.each do |reading|
        time_diff = @current_reading.hours_diff(reading)
        if time_diff > RETENTION
          @data.delete(reading)
          next
        elsif time_diff > LOW_HIGH_THRESHOLD
          return sms_content(reading) if @current_reading.slope(reading) < LOW_SLOPE
        elsif time_diff > MIN_THRESHOLD
          return sms_content(reading) if @current_reading.slope(reading) < HIGH_SLOPE
        end
      end
    end

    def sms_content(reading)
      "dummy text"
    end
  end
end