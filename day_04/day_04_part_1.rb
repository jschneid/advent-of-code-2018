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

def get_guard_with_most_minutes_asleep(guard_schedules)
  sleepiest_guard_id = ''
  most_minutes_asleep = -1

  guard_schedules.each do |guard_id, guard_shifts|
    minutes_asleep = 0
    guard_shifts.each do |shift|
      minutes_asleep += shift.count
    end
    if minutes_asleep > most_minutes_asleep
      most_minutes_asleep = minutes_asleep
      sleepiest_guard_id = guard_id
    end
  end

  sleepiest_guard_id
end

def get_sleepiest_minute(guard_schedule)
  sleeping_minutes = Hash.new(0)

  guard_schedule.each do |shift|
    shift.each do |minute|
      sleeping_minutes[minute] += 1
    end
  end

  sleeping_minutes.key(sleeping_minutes.values.max)
end

guard_schedules = get_guard_schedule

sleepiest_guard_id = get_guard_with_most_minutes_asleep(guard_schedules)

sleepiest_minute = get_sleepiest_minute(guard_schedules[sleepiest_guard_id])

p sleepiest_guard_id.to_i * sleepiest_minute
