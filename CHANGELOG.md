## v1.0.1

`wants.any` and `wants.not_acceptable` no longer return nil if they
don't match. This means the following will now properly return the HTML
response:

```ruby
wants = Wants.new('text/html', [ :html ])
wants.html { '<p>an HTML response</p>' }
wants.not_acceptable { '406: Not Acceptable' }
```

## v1.0.0

Initial version. Support for `Wants.new(accept_header, list_of_mime_types)`
and `use Wants::ValidateAcceptsMiddleware, :mime_types => list_of_mime_types`.
