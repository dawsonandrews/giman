# Giman

Giman makes uploading files directly to AWS S3 a breeze. It supports a modern JS evented interface with built in support for drag and drop uploads.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'aws-sdk', '>= 2.0'
gem 'giman'
```

Setup Aws (config/initializers/aws.rb)
```rb
Aws.config.update({
  region: ENV.fetch("AWS_REGION", "us-east-1"),
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
})
```

Setup Aws S3 bucket CORS policy
```xml
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>Authorization</AllowedHeader>
        <AllowedHeader>Content-Type</AllowedHeader>
        <AllowedHeader>Origin</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
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

Include giman application helpers in your application record or models
```rb
class ApplicationRecord < ActiveRecord::Base
  include Giman::AttachmentHelpers
  self.abstract_class = true
end
```

Include giman helpers in ApplicationController
```rb
helper Giman::ApplicationHelper
```

## Usage

### Rails helpers

```rb
# Multiple fields
giman_hidden_fields(product.images, param: "product[image_ids][]")
# Single field
giman_hidden_field(user.avatar, param: "user[avatar_id]")

# File input field
giman_file_field("product[image_ids][]", id: "giman-file-input-1", style: "display: none", multiple: true, data: {supported_types: "image/jpeg,image/jpg,image/png,image/gif"})
```

```html
<%= giman_dropbox_field("product[image_ids][]", style: "height: 120px; border: dashed 2px #ccc;", multiple: true, class: "file-upload-dropbox", data: {giman_drop_upload: "giman-file-input-1", supported_types: "image/jpeg,image/jpg,image/png,image/gif"}) do %>
  <span class="upload-text" style="text-align:center;">Drop files or click here to upload</span>
<% end %>
```

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
