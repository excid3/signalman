# Signalman
A debug tool for Ruby on Rails application.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
bundle add "signalman", group: :development
```

Add migrations
```ruby
bin/rails signalman:install:migrations
```

Mount to the Rails routes
```ruby
mount Signalman::Engine => "/signalman" if Rails.env.development?
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
