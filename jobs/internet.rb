SCHEDULER.every "30m", :first_in => 0 do |job|
  usage = Internet.usage
  send_event('internet', current: usage[:usage], moreinfo: usage[:quota])
end
