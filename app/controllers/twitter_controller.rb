class TwitterController < ApplicationController
  def index
    @twitter ||= MyTwitter.new
  end

  def tweet
    @twitter ||= MyTwitter.new
    if @twitter && !params[:tag].empty?
    # if @twitter.valid?
      @twitter.tag = params[:tag].clone
      tag = @twitter.tag.slice(0) == '#' ?  @twitter.tag.slice(1, 999) : @twitter.tag
      tag << " filter:safe" if params[:safe] == 'ON'
      tag << " -filter:safe" if params[:safe] == 'ERO'
      tag << " filter:media" if params[:media] == 'ON'
      tag << " exclude:retweets" if params[:rt] == 'OFF'

      @twitter.tweet = []
      @twitter.client.search("##{tag}", lang: "ja", result_type: params[:type], count: params[:limit], filter: "images").map do |tweet|
        next if tweet.media.empty?
        break if @twitter.tweet.size > params[:limit].to_i
        ret = {
                icon: tweet.user.profile_image_url,
                name: tweet.user.name,
                text: tweet.text,
                rt: tweet.retweet_count,
                media_url: []
              }
        tweet.media.each do |media|
          ret[:media_url] << media.media_url
        end
        @twitter.tweet << ret
      end
      @twitter.tweet.sort! do |a, b|
        b[:rt] <=> a[:rt]
      end
    end
    @twitter.tag = params[:tag]
    render action: 'index'
  rescue => e
    logger.error e.message
    flash[:error] = "エラーが起きました[#{e.message}]"
    @twitter.tag = params[:tag]
    render action: 'index'
  end
end