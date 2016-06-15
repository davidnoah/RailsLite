require 'json'

class Session
  attr_reader :session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookies = req.cookies
    if cookies["_rails_lite_app"]
      @session = JSON.parse(cookies["_rails_lite_app"])
    else
      @session = {}
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    attributes = { value: JSON.generate(@session), path: "/" }
    res.set_cookie("_rails_lite_app", attributes)
  end
end
