class EchosController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_token, only: :create

  def create
    args_echo = Echo.to_args(params)
    args_user = User.to_args(params)
    user = User.find_by(google_credentials: args_user[:google_credentials])

    outlets = user.accounts
    echos = Echo.build_for_each_outlet(outlets, args_echo)
    echos.each {|e| user.echos << e}
    facebook_client = init_facebook(user)
    twitter_client = init_twitter(user)

    begin
      echos.each{|e| update_if_facebook(facebook_client, e)}
    rescue Exception => err
      p "Facebook update error occured: #{err}"
    end

    begin
      echos.each{|e| update_if_twitter(twitter_client, e)}
    rescue Exception => err_two
      p "Twitter update error occurred: #{err_two}"
    end

    render status: 200
  end

  def new
    @echo = Echo.new
  end

  def expand
    @echo = Echo.find_by(short_url: params[:short_url] )
    redirect_to @echo.long_url
  end

  private

  def init_facebook(user)
    begin
      Koala::Facebook::API.new(user.facebook_token, ENV["FACEBOOK_SECRET"])
    rescue Exception => e
      p "Facebook auth error: #{e}"
    end
  end

  def init_twitter(user)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = user.twitter_token
      config.access_token_secret = user.twitter_token_secret
    end
    client
  end

  def update_if_twitter(client, echo)
    if !(echo.is_draft) && echo.send_to_venue == "twitter"
      client.update("#{echo.body} #{expand_url(echo.short_url)}")
    end
    return echo.send_to_venue
  end

    def update_if_facebook(client, echo)
      if !(echo.is_draft) && echo.send_to_venue == "facebook"
        user = client.get_object('me')
        client.put_wall_post(echo.user_text, {
          "link" => expand_url(echo.short_url),
          "caption" => echo.domain_name,
          "description" => echo.quoted_content
        })
      end
      # return echo.send_to_venue
    end

end