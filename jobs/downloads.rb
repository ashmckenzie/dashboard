DOWNLOADS_CONFIG = $APP_CONFIG.downloads

SCHEDULER.every DOWNLOADS_CONFIG.refresh, :first_in => 0 do |job|
  detail = Downloads::Sabnzbd.status
  send_event('downloads-queue', { items: detail[:queue][:jobs] })
  send_event('downloads-history', { items: detail[:history][:jobs] })
end
