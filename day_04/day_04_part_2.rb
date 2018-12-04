def get_guard_schedule
  guards = {}
  guard_id = 0
  sleep_start_minute = 0
  File.readlines('input.txt').each do |line|
    if line.include?('Guard')
      guard_id = line[26..29]
      guards[guard_id] = [] if guards[guard_id].nil?
    elsif line.include?('falls asleep')
      sleep_start_minute = line[15..16].to_i
    else
      sleep_end_minute = line[15..16].to_i
      sleep_minutes = []
      (sleep_start_minute..(sleep_end_minute - 1)).each do |minute|
        sleep_minutes << minute
      end
      guards[guard_id] << sleep_minutes
    end
  end
  guards
end

def get_sleepiest_minute(guard_schedule)
  sleeping_minutes = Hash.new(0)

  guard_schedule.each do |shift|
    shift.each do |minute|
      sleeping_minutes[minute] += 1
    end
  end

  minute_and_minutes_asleep = sleeping_minutes.max_by{|minute, minutes_asleep| minutes_asleep}
  minute_and_minutes_asleep
end

guard_schedules = get_guard_schedule

guard_sleepiest_minute_and_minutes_asleep = {}

guard_schedules.each do |guard_id, guard_schedule|
  minute_and_minutes_asleep = get_sleepiest_minute(guard_schedule)
  guard_sleepiest_minute_and_minutes_asleep[guard_id] = minute_and_minutes_asleep unless minute_and_minutes_asleep.nil?
end

guard_id_and_sleepiest_minute_and_minutes_asleep = guard_sleepiest_minute_and_minutes_asleep.max_by{|guard_id, guard_sleepiest_minute_and_minutes_asleep| guard_sleepiest_minute_and_minutes_asleep[1]}

p guard_id_and_sleepiest_minute_and_minutes_asleep[0].to_i * guard_id_and_sleepiest_minute_and_minutes_asleep[1][0]
