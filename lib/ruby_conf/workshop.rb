module RubyConf
  class Workshop
    def initialize(title:, starts_at:, capacity:, speaker:, description:)
      @title = title
      @starts_at = starts_at
      @capacity = capacity
      @speaker = speaker
      @description = description
    end

    attr_reader :title, :starts_at, :capacity, :speaker, :description

    def self.from_json(json)
      speaker = yield(json[:speaker])
      raise(RecordNotFound, "Speaker '#{json[:speaker]}' was not found") unless speaker

      new(
        title: json[:title],
        starts_at: Time.iso8601(json[:starts_at]),
        capacity: json[:capacity],
        speaker: speaker,
        description: json[:description]
      )
    end

    def match?(string)
      regexp = Regexp.compile(Regexp.escape(string), Regexp::IGNORECASE)
      title.match?(regexp) || description.match?(regexp) || speaker.name.match?(regexp)
    end
  end
end
