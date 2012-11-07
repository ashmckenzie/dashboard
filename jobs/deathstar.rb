cpu_image_uri = 'http://stats.the-rebellion.net/deathstar/deathstar/cpu-day.png'
memory_image_uri = 'http://stats.the-rebellion.net/deathstar/deathstar/memory-day.png'

SCHEDULER.every "5m", :first_in => 0 do |job|
  send_event('server-deathstar-cpu', image: cpu_image_uri)
  send_event('server-deathstar-memory', image: memory_image_uri)
end
