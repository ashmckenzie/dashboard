module Downloads

  class Sabnzbd

    def self.queue
      detail = {
        apikey: $APP_CONFIG.downloads.api_key
      }

      uri_options = "&apikey=%<apikey>s"
      uri = URI.parse("#{$APP_CONFIG.downloads.base_uri}/sabnzbd/api?mode=qstatus&output=json&#{sprintf(uri_options, detail)}")

      response = JSONGet.request(uri.to_s)

      {
        :jobs => response.jobs.map { |job| { label: job.filename, value: job.timeleft }}
      }
    end
  end
end
