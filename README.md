# RackEncodingScrubber

*Removes* invalid percent encodings, like:

```
ArgumentError: invalid %-encoding (%u00fcbersetzer)
```


## Installation

Add this line to your application's Gemfile:

    gem 'rack_encoding_scrubber'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack_encoding_scrubber

## Usage

add to config/application.rb:

```ruby
  config.middleware.insert_before "Rack::Runtime", "RackEncodingScrubber"
```


