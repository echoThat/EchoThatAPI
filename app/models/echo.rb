class Echo < ActiveRecord::Base
  validates_uniqueness_of :short_url
  after_create :make_short_url

  belongs_to :user

  def self.echo_params(json_hashified)
    permitted = Echo.new.attributes.keys
    return json_hashified.select{|k,v| permitted.include?(k.to_s)}
  end

  def self.to_args(json_params)
    args = self.sanitize_json(json_params)
  end

  def make_short_url
    salt = (0..2).map{|n| rand(36).to_s(36) }.join
    id_part = self.id.to_s(36).upcase[0..1]
    self.update_attribute(:short_url, salt + id_part)
  end

  def self.build_for_each_outlet(outlets, args)
    echos = []
    outlets.each do |site|
      if !args[:is_draft]
        to_send = Echo.new(Echo.echo_params(args))
        to_send.send_to_venue = site
        echos << to_send
      else
        draft = Echo.new(echo_params(args))
        echos << draft
      end
    end
    echos
  end

  private

  def self.sanitize_json(json_obj)
    received = JSON.parse(json_obj.first[0])
    hash = {}
    hash[:is_draft] = received.fetch("is_draft", false)
    hash[:long_url] = self.sanitize_url( received.fetch("url") )

    self.format_post_parts!(received, hash)

    return hash
  end

  def self.format_post_parts!(received, output_hash)
    content = received.fetch("message", "")
    output_hash[:user_text] = content.fetch("userText", "")
    output_hash[:quoted_content] = content.fetch("echoQuote", "")

    self.decode_chars(output_hash[:user_text])
    self.decode_chars(output_hash[:quoted_content])

    #for outlets that take a full string
    output_hash[:body] = [output_hash[:quoted_content], output_hash[:user_text]].join(" ")
    output_hash
  end

  def self.sanitize_url(url)
    if /\?/.match(url) && !(/\/\?/.match(url))
      return url.gsub("?","/?")
    else
      return url
    end
  end

  def self.decode_chars(str)
    str.gsub!("etcode4osqbr", "[")
    str.gsub!("etcode4csqbr", "]")
  end

end