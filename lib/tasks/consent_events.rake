# frozen_string_literal: true

namespace :consent_events do
  desc "Truncate log/consent_events.jsonl (e.g. after archival). Use with care."
  task truncate: :environment do
    path = Rails.root.join("log", ConsentEventLogger::LOG_BASENAME)
    next unless path.file?

    File.truncate(path, 0)
    puts "Truncated #{path}"
  end
end
