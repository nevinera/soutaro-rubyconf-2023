module RubyConf
  class Conference
    attr_reader :speakers, :talks, :workshops

    def initialize()
      @speakers = []
      @talks = []
      @workshops = []
    end

    def self.load(path)
      conference = Conference.new()
      conference.load(YAML.load_file(path, symbolize_names: true))
      conference
    end

    def load(content)
      @speakers = []
      @talks = []

      content[:speakers].each do |json|
        speakers << Speaker.from_json(json)
      end

      speakers.sort_by! {|s| s.name }

      content[:talks].each do |json|
        talks << Talk.from_json(json) {|name| find_speaker(name) }
      end

      content[:workshops].each do |json|
        workshops << Workshop.from_json(json) { |name| find_speaker(name) }
      end
    end

    def find_speaker(name)
      speakers.find {|speaker| speaker.name == name }
    end

    def talks_at(time)
      talks.select do |talk|
        talk.time_range.cover?(time)
      end
    end

    def next_talk(of:, in_room:)
      talks.select {|talk| talk.room == in_room }
      following_talks = talks.select {|talk| of.ends_at <= talk.starts_at }
      following_talks.min_by {|talk| talk.starts_at }
    end
  end
end
