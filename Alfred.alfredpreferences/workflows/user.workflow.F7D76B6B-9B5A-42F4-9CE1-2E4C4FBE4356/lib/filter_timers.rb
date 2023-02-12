require 'json'

def get_timers
  items = Dir['timer_*.txt'].map do |file|
    remainder = File.read(file)
    {
      uid: file,
      valid: false,
      title: remainder,
      subtitle: "Timer with #{remainder} left, ⌘+⏎ to remove.",
      text: {
        copy: remainder,
        largetype: "#{remainder} seconds left!"
      },
      mods: {
        cmd: {
          arg: file,
          valid: true,
          subtitle: "Remove timer with #{remainder} left"
        }
      }
    }
  end

  { items: items }.to_json
end
