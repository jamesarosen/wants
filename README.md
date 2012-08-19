## Wants

This library provides support for choosing the proper MIME type for a
response.

### Installation

With Rubygems:

```ruby
gem install wants
```

With Bundler:

```ruby
gem 'wants'
```

### Loading

Simply require the gem name:

```ruby
require 'wants'
```

### Usage

#### `Wants.new`

```ruby
wants = Wants.new( env, [ :html, :json, :atom ] )
```

The `Wants` constructor takes two arguments:

 * a [`Rack`](http://rack.github.com/)-style `env` `Hash`. Specifically, the
   hash should have an `"HTTP_ACCEPT"` key with a value that conforms to
   [RFC 2616, §14.1](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1)
 * an `Array` of all the supported MIME types, each of which can be a full
   type (e.g. `"application/json"`) or, if `Rack` is loaded, a key in
   [`Rack::Mime::MIME_TYPES`](https://github.com/rack/rack/blob/master/lib/rack/mime.rb).
   (If you want to use a different lookup table, you can set `Wants.mime_lookup_table`.)

`Wants.new` will return to you a `Wants::MatchResult` object that represents the
single best MIME type from the available options. It supports a variety of
introspection methods:

#### `MatchResult#not_acceptable?`

This predicate tell you whether there was no acceptable match. For example,

```ruby
acceptable = 'application/json'
offered = [ :html ]
wants = Wants.new( { 'HTTP_ACCEPT' => acceptable }, offered )
wants.not_acceptable? # true
```

This method is aliased as `#blank?` and its inverse is available as `#present?`.

#### `MatchResult#{mime}?`

You can use a MIME abbreviation as a query method on the matcher. For example,

```ruby
acceptable = 'text/html,application/xhtml+xml;q=0.9'
offered = [ :html, :json ]
wants = Wants.new( { 'HTTP_ACCEPT' => acceptable }, offered )
wants.html?  # true
wants.xhtml? # false
wants.json?  # false
```

#### `MatchResult#[{mime}]`

To query a full MIME type, use `#[]`. For example,

```ruby
acceptable = 'text/html,application/xhtml+xml;q=0.9'
offered = [ :html, :json ]
wants = Wants.new( { 'HTTP_ACCEPT' => acceptable }, offered )
wants[:html]                    # true
wants['text/html']              # true
wants['application/xhtml_xml']  # false
wants['application/json']       # false
```

#### `MatchResult#{mime}`

Lastly, you can use the matcher as DSL. For example,

```ruby
acceptable = 'application/json,application/javascript;q=0.8'
offered = [ :html, :json ]
wants = Wants.new( { 'HTTP_ACCEPT' => acceptable }, offered )

wants.atom           { build_an_atom_response }
wants.json           { build_a_json_response }
wants.html           { build_an_html_response }
wants.not_acceptable { build_a_406_unacceptable_response }
wants.any            { build_a_generic_response }
```

In this example, only `build_a_json_response` will be evaluated. `wants.json`
and all subsequent `wants.{mime}` calls, including `wants.not_acceptable` and
`wants.any`, will return whatever `build_a_json_response` returned.
More formally, each `wants.{mime}` call behaves as follows:

 1. if `@response_value` is not `nil`, return it
 1. if [method name] is the abbreviation for the desired MIME type,
    evaluate the block and set the result to `@response_value`

`wants.not_acceptable` will match if `wants.not_acceptable?` returns `true`.
`wants.any` will match if `wants.not_acceptable?` returns `false`. Thus,
`wants.any` should be placed after all other matchers.

#### `Wants::ValidateAcceptsMiddleware`

Usage in `config.ru`:

```ruby
require 'wants/validate_accepts_middleware'

use Wants::ValidateAcceptsMiddleware, :mime_types => [ :html, :json ]
run MyApp
```

This will pass HTML and JSON requests down to `MyApp` and return a
406 Not Acceptable response for all others. You can configure the
failure case with the `:on_not_acceptable` option:

```ruby
use Wants::ValidateAcceptsMiddleware,
  :mime_types => [ ... ],
  :on_not_acceptable => lambda { |env| ... }
```
