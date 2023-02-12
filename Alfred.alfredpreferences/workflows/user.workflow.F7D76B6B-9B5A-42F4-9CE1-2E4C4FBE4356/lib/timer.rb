require 'fileutils'

class Sleeper
  def self.wait
    sleep 1
  end
end

def format_timer(total_seconds)
  seconds = (total_seconds % 60).to_i
  minutes = ((total_seconds / 60) % 60).to_i
  hours = (total_seconds / (60 * 60)).to_i
  time = format('%02ds', seconds)
  time = format('%02d:%02d', minutes, seconds) if minutes != 0 || hours != 0
  time = "#{hours}:#{time}" if hours != 0
  time
end

def seconds_from_string(time_string)
  run_seconds = 0
  time_string.split(' ').each do |digit|
    run_seconds += case digit
                   when /\d+d/
                     digit.sub('d', '').to_i * 86_400
                   when /\d+h/
                     digit.sub('h', '').to_i * 3600
                   when /\d+m/
                     digit.sub('m', '').to_i * 60
                   else
                     digit.sub('s', '').to_i
                   end
  end
  run_seconds
end

def set_timer(time_string)
  start_time = Time.now

  timer_file = "timer_#{rand(1..10_000)}.txt"
  timer_file = "timer_#{rand(1..10_000)}.txt" while File.exist?(timer_file)

  FileUtils.touch(timer_file)

  run_seconds = seconds_from_string(time_string)

  while Time.now < (start_time + run_seconds)
    Sleeper.wait
    return '' unless File.exist?(timer_file)

    File.write(timer_file, format_timer(start_time - Time.now + run_seconds))
  end

  FileUtils.rm(timer_file)

  "#{format_timer(run_seconds)} timer is done!"
end
