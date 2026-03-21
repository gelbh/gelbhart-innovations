# frozen_string_literal: true

# Persists consent snapshots as JSON lines (no ActiveRecord in this app).
# Rotate or archive log/consent_events.jsonl for retention.
class ConsentEventLogger
  LOG_BASENAME = 'consent_events.jsonl'

  class << self
    def append(choices:, policy_version:, region:, locale:, session_fingerprint:)
      payload = {
        recorded_at: Time.now.utc.iso8601, policy_version:, choices:, region:, locale:,
        session_fingerprint:
      }
      write_line("#{payload.to_json}\n")
    end

    private

    def write_line(line)
      dir = Rails.root.join('log')
      FileUtils.mkdir_p(dir)
      path = dir.join(LOG_BASENAME)
      File.open(path, File::CREAT | File::APPEND | File::WRONLY, 0o644) do |f|
        f.flock(File::LOCK_EX)
        f.write(line)
      end
    end
  end
end
