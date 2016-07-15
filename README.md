#Rails Lite

Rails Lite is a web server MVC framework inspired by the functionality of Ruby on Rails.

##Features

###Server

A simple server is implemented using the `Rack` module.

```Ruby
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
```

###ControllerBase

`ControllerBase` has similar functionality to Rails' `ActiveController::Base`. The `ControllerBase` class initializes with request and response objects as arguments. Similarly to `ActiveController::Base`, it has `render` and `redirect_to` methods. The `render` function utilizes the uncommonly used `binding` method to capture the instance variables used in the template that belong to the controller class. 

```Ruby
def render(template_name)
  controller_name = self.class.name.underscore
  path = "views/#{controller_name}/#{template_name.to_s}.html.erb"

  template = File.read(path)
  erb_template = ERB.new(template).result(binding)

  render_content(erb_template, 'text/html')
end
```

A `Session` class was also developed so that a cookie could be attached to the response and stored on the client's browser. Rack's `set_cookie` method was used for this.

```Ruby
#session.rb

def store_session(res)
  res.set_cookie('_rails_lite_app', {path: "/", value: @data.to_json} )
end
```

###Router

The `Router` class finds and invokes the appropriate controller action by matching the request's URL path (/users/17) and method (GET, POST, etc.) to a Route's URL pattern and HTTP method, respectively. The route also sends `params` to the controller class.

```Ruby
#router.rb

def matches?(req)
  @pattern =~ req.path && @http_method.to_s.upcase == req.request_method
end
```

##Todo

- [ ] Integrate a version of ActiveRecord
