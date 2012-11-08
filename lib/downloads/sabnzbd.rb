module Downloads

  class Sabnzbd

    def self.status
      {
        :queue => queue,
        :history => history
      }
    end

    def self.queue
      detail = {
        apikey: $APP_CONFIG.downloads.api_key
      }

      uri_options = "&apikey=%<apikey>s"
      uri = URI.parse("#{$APP_CONFIG.downloads.base_uri}/sabnzbd/api?mode=qstatus&output=json&#{sprintf(uri_options, detail)}")

      response = JSONGet.request(uri.to_s)

      {
        :jobs => response.jobs.map { |job| { label: job.filename, value: job.timeleft.gsub(/:\d+$/, '') }}
      }
    end

    def self.history
      detail = {
        apikey: $APP_CONFIG.downloads.api_key
      }

      uri_options = "&apikey=%<apikey>s"
      uri = URI.parse("#{$APP_CONFIG.downloads.base_uri}/sabnzbd/api?mode=history&output=json&#{sprintf(uri_options, detail)}")

      response = JSONGet.request(uri.to_s)

      {
        :jobs => response.history.slots.map { |slot| { label: slot.name, value: '' }}
      }
    end
  end
end
