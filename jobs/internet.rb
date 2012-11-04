SCHEDULER.every "30m", :first_in => 0 do |job|
  usage = Internet.usage
  data = {
    usage: usage[:usage],
    quota: usage[:quota],
    percentUsed: ((usage[:usage].to_f / usage[:quota].to_f) * 100).to_i
  }
  send_event('internet', data)
end
