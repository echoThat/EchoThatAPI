class User < ActiveRecord::Base
  has_many :echos

  def drafts
    echos.select{|e| e.is_draft}
  end

  def twitter_history
    echos.select{|e| e.sent_to_venue.downcase == "twitter"}
  end

  def self.to_args(json_params)
    args = self.sanitize_json(json_params)
    return args
  end

  private

  def self.sanitize_json(json_params)
    hash = JSON.parse(json_params.first[0])
    safe_args = {}

    safe_args[:google_credentials] = hash.fetch("google_credentials", nil)
    safe_args[:twitter_on] = hash.fetch("twitter_on", true)
    safe_args[:facebook_on] = hash.fetch("facebook_on", true)
    safe_args[:facebook_char_floor] = hash.fetch("facebook_char_floor", true)
    safe_args[:always_link] = hash.fetch("always_link", true)

    user_args = self.user_params_only(safe_args)
    {:user => user_args}
  end

  def self.user_params_only(json_hashified)
    permitted = User.new.attributes.keys
    return json_hashified.select{|k,v| permitted.include?(k.to_s)}
  end

end
