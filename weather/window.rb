require 'json'

module Weather
  class Window
    FILE_NAME = Config::Weather::Window::FILE_NAME

    def load_file
      @data = JSON.parse(File.read(FILE_NAME))
    end

    def save_file
      File.write(FILE_NAME, @data.to_json)
    end

    def add_reading(reading)
      @current_reading = reading
      @data << reading
    end

    def analyze
      current_time = Time.at(@current_reading[:time])
      @data.dup.each do |reading|

      end
    end

    def 
  end
end