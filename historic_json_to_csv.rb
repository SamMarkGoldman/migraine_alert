require 'csv'
require 'json'

import_file = ARGV[0]
export_file = ARGV[1] || import_file.split('.')[0] + '.csv'

raw_json = File.read(import_file)
data = JSON.parse(raw_json)

CSV.open(export_file, "wb") do |csv|
  csv << data.first.keys
  data.each do |row|
    csv << row.values
  end
end