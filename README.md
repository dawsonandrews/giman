# Giman

Giman makes uploading files directly to AWS S3 a breeze. It supports a modern JS evented interface with built in support for drag and drop uploads.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'giman'
```

Setup Aws (config/initializers/aws.rb)
```rb
Aws.config.update({
  region: ENV.fetch("AWS_REGION", "us-east-1"),
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
})
```

And then execute:
```bash
$ bundle
$ bin/rails giman:install:migrations
$ bin/rails db:migrate
```

Require giman JS (ensure it is after jquery)
```js
//= require jquery
//= require giman/giman
```

## Usage

### Listen out for events

```js
$(document).on("directUpload:started", function(ev, args) {
  console.log("directUpload:started", args);
});

$(document).on("directUpload:failed", function(ev, args) {
  console.error("directUpload:failed", args.message);
});

$(document).on("directUpload:progress", function(ev, args) {
  console.log("directUpload:progress", args.percentLoaded+"%");
});

$(document).on("directUpload:complete", function(ev, args) {
  console.log("directUpload:complete", args.fileData);
});
```

## Contributing
Contributions are welcome.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
