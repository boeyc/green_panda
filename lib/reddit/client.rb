require 'json'
require 'digest/md5'
require 'open-uri'

module Reddit
  class Client
    def self.fetch subreddit
      new.fetch subreddit
    end

    def fetch subreddit
      records = JSON.parse get subreddit
      records.each do |hash|
        checksum = Digest::MD5.hexdigest Marshal.dump(hash)
        hash['checksum'] = checksum
      end
      records
    end

    private

    ## Returns user feed as JSON
    def get subreddit
      open("http://www.reddit.com/r/#{subreddit}.json").read
    end
  end
end
