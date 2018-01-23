class MyTwitter
  include ActiveModel::Model

  attr_accessor :tag, :limit, :tweet, :rt, :safe, :media, :type

  validates :tag, presence: true

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    end
  end
end
