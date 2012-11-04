image_uri = 'http://stats.the-rebellion.net/deathstar/deathstar/cpu-day.png'

SCHEDULER.every "5m", :first_in => 0 do |job|
  send_event('server-deathstar', image: image_uri)
end
