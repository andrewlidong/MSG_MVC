# MSG MVC
MSG MVC is a lightweight MVC Framework inspired by Ruby on Rails. 

Functionality:
* Rayquaza ORM
* Basic Search Functions
* Model Associations 
* Controllers with flash and session functionality
* CSRF attack protection
* Regex routing
* Middleware
* Server Integration

## ORM
MSG MVC incorporates all the functionality of RayquazaORM, a lightweight Object Relational Mapping system that supports SQL queries.  For more details click [here](https://github.com/andrewlidong/RayquazaORM)

1. Basic search functions such as all and find
2. Insert and update values
3. Build associations such as has_many, belongs_to and has_one_through

## Flash and Session Functions

#### `redirect_to (url)`
Redirects to particular render.  Returns an error if already built.  

Example:
```rb
  def redirect_to(url)
    raise "Double Render Error" if already_built_response?
    @res.location = url
    @res.status = 302
    session.store_session(@res)
    flash.store_flash(@res)
    @already_built_response = true
  end
```

#### `render(content, content_type)`
Renders view, raising error if already built.  

Example:
```rb
  def render_content(content, content_type)
    raise "Double Render Error" if already_built_response?
    @res.write(content)
    @res["Content-Type"] = content_type
    session.store_session(@res)
    flash.store_flash(@res)
    @already_built_response = true
  end

  def render(template_name)
    dir_path = File.dirname(__FILE__)
    template_fname = File.join(
      dir_path, "..",
      "views", self.class.name.underscore, "#{template_name}.html.erb"
    )

    template_code = File.read(template_fname)

    render_content(
      ERB.new(template_code).result(binding),
      "text/html"
    )
  end
```

#### `flash`
Returns a hash-like object that is available for the current and next request cycle.  Receives a request and retrieves its contents from a cookie.  

#### `flash.now`
Returns a hash-like object that is available for the current cycle.  

Example:
```rb
class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_rails_lite_app_flash']

    @now = cookie ? JSON.parse(cookie) : {}
    @flash = {}
  end

  def [](key)
    @now[key.to_s] || @flash[key.to_s]
  end

  def []=(key, value)
    @flash[key.to_s] = value
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', value: @flash.to_json, path: '/')
  end
end
```

## CSRF Protection
CSRF is used to determine if a form is valid.  It validates the authenticity token for all requests other than GET requests to the controller.  `form_authenticity_token` provides a way to include the CSRF token in their form.  

Example: 
```rb
  def protect_from_forgery?
    @@protect_from_forgery
  end

  def form_authenticity_token
    @token ||= generate_authenticity_token
    res.set_cookie('authenticity_token', value: @token, path: '/')
    @token
  end

  def check_authenticity_token
    cookie = @req.cookies["authenticity_token"]
    unless cookie && cookie == params["authenticity_token"]
      raise "Invalid authenticity token"
    end
  end

  def generate_authenticity_token
    SecureRandom.urlsafe_base64(16)
  end
```

## Regex Routing
We require a route's pattern argument to be a regular expression.  

Example:
```rb
class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @http_method = http_method
    @pattern = pattern
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    @pattern =~ req.path && @http_method == req.request_method.downcase.to_sym
  end

  def run(req, res)
    match_data = @pattern.match(req.path)
    route_params = Hash[match_data.names.zip(match_data.captures)]

    @controller_class
      .new(req, res, route_params)
      .invoke_action(action_name)
  end
end

```