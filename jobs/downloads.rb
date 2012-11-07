DOWNLOADS_CONFIG = $APP_CONFIG.downloads

SCHEDULER.every DOWNLOADS_CONFIG.refresh, :first_in => 0 do |job|
  queue = Downloads::Sabnzbd.queue
  data = { items: queue[:jobs] }
  send_event('downloads', data)
end
