require 'rails_helper'

RSpec.describe Echo, :type => :model do

  let(:params){{
    "{\"message\":{\"echoQuote\":\"\\\"hile a development mode is typically great for development, it’s not so grea\\\"\",\"userText\":\"sadfsdfs\"},\"url\":\"https://devcenter.heroku.com/articles/config-vars\",\"google_credentials\":\"echothatechothat@gmail.com\",\"chrome_token\":\"m4o1yhpvxcq5e0zgk9jabisun\"}"=>nil
  }}

  it "should produce a hash with default values to_args class method" do
    args = Echo.to_args(params)
    defaults = [:is_draft, :body, :long_url]
    defaults.each do |attrib|
      expect(args.keys.include?(attrib)).to be true
    end
  end

  it "should create a new Echo with self-sanitized params" do
    args = Echo.to_args(params)
    echo = Echo.new(args)
    expect(echo).to be_a Echo
    expect(echo.save).to be true
  end

  it "should handle args that have too many keys" do
    args = Echo.to_args(params)
    args[:google_credentials] = "jajajajajajajajajaja5555"
    expect(Echo.create(Echo.echo_params(args))).to be_a Echo
  end

  it "can generate an array of echos to different venues" do
    args = Echo.to_args(params)
    user = create(:valid_user)
    outlets = user.accounts
    echos = Echo.build_for_each_outlet(outlets, args)
    echos.each{|e| e.save}
    expect(echos.select{|e|e.send_to_venue == "twitter"}[0]).to be_a Echo
    expect(echos).to be_a Array
  end

  it "can save an array of echos on the right user" do
    args = Echo.to_args(params)
    user = create(:valid_user)
    before = user.echos.count
    outlets = user.accounts
    echos = Echo.build_for_each_outlet(outlets, args)
    echos.each do |e|
      user.echos << e
    end
    expect(user.echos.count > before).to be true
  end

  it "should have user text and quoted text separately"

  it "should have quotes on either end of quoted text"

  it "should encoded square brackets correctly"

end
