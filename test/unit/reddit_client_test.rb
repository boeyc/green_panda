require 'minitest/autorun'
require 'reddit/client'

module Reddit
  class ClientTest < MiniTest::Unit::TestCase
    attr_reader :sample_json

    def setup
      @sample_json = File.read 'test/assets/mjsubreddit.json'
    end

    def test_mjsubreddit
      tc = self
      sample = sample_json
      klass = Class.new(Client) do
        define_method(:get) do |subreddit|
          tc.assert_equal 'marijuana', subreddit
          sample
        end
      end

      events = klass.fetch 'marijuana'
      assert_operator events.length, :>, 0
    end

    def test_checksum
      sample = sample_json
      klass = Class.new(Client) do
        define_method(:get) do |username|
          sample
        end
      end
      events = klass.fetch 'tenderlove'
      assert events.first['checksum'], 'needs checksum'

      checksums = events.map { |e| e['checksum'] }
      assert_equal events.length, checksums.uniq.length
    end
  end
end
