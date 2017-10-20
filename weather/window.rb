require 'json'

module Weather
  class Window
    FILE_NAME = Config::Weather::Window::FILE_NAME
    RETENTION = Config::Weather::Window::RETENTION_DAYS
    LOW_HIGH_DAYS_THRESHOLD = Config::Weather::Window::LOW_HIGH_DAYS_THRESHOLD
    MIN_DAYS_THRESHOLD = Config::Weather::Window::MIN_DAYS_THRESHOLD
    LOW_SLOPE = Config::Weather::Window::LOW_SLOPE
    HIGH_SLOPE = Config::Weather::Window::HIGH_SLOPE
    MAX_PRESSURE = Config::Weather::Window::MAX_PRESSURE

    def load_file
      @data = JSON.parse(file_content).map { |r| Weather::Reading.from_hash(r) }
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
        time_diff = @current_reading.days_diff(reading)
        if reading == @current_reading
          next
        elsif time_diff > RETENTION
          @data.delete(reading)
          next
        elsif reading.pressure_diff(@current_reading) < 0.6
          next
        elsif @current_reading.pressure >= MAX_PRESSURE
          next
        elsif time_diff > LOW_HIGH_DAYS_THRESHOLD
          return generate_message(reading) if reading.slope(@current_reading) < LOW_SLOPE
        elsif time_diff > MIN_DAYS_THRESHOLD
          return generate_message(reading) if reading.slope(@current_reading) < HIGH_SLOPE
        end
      end
      nil
    end

    def generate_message(reading)
      # "#{reading.time} -- #{reading.slope(@current_reading)} -- #{reading.pressure_diff(@current_reading)}"
      { initial: reading, final: @current_reading }
    end
  end
end