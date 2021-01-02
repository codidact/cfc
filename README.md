# cfc
Simple library for interacting with the Cloudflare API.

## Install
```
gem install cfc
```

If you're installing for development/contribution, just clone the repository.

## Usage
Once you've `require`d the gem, you _must_ then configure it with required credentials before you can use it. You can do
this by calling `CFC::Config.configure`, as shown below. You must provide a valid API token for the gem to use in API
requests.

```ruby
CFC::Config.configure do |config|
  config.token = 'your_api_token_here'
end
```

Alternatively, you can authenticate with your API key and email address:

```ruby
CFC::Config.configure do |config|
  config.api_key = 'your_api_key_here'
  config.api_email = 'your_email_here'
end
```

You can then use the library either by instantiating `CFC::API` and using that class to send API requests directly,
or, you can use pre-provided objects in `lib/objects/`, which represent a data type from the Cloudflare API and may
provide methods to perform common or simple tasks on those types. For instance, to list DNS records in all zones you
administer (assuming you've already configured the gem as above):

```ruby
CFC::Zone.list.each do |zone|
  puts zone.records
end
```

Or if you need to roll all of your current API tokens:

```ruby
new_tokens = CFC::UserAPIToken.list.each do |token|
  token.roll['result']
end

# Once you've rolled tokens, of course, your existing token won't work, so you
# probably want to update that.
CFC::Config.configure do |config|
  config.token = new_tokens[0]
end
```

## Contributing
As with all Codidact projects, contributions are welcome and must adhere to the
[Codidact Code of Conduct](https://meta.codidact.com/policy/code-of-conduct). Please create an issue to discuss any
major changes you propose to make, or if you think your changes may not be accepted for any reason&mdash;we'd always
rather discuss something unnecessarily than have to reject someone's hard work.

## License
This project is licensed under the terms of the MIT license, which may be found in the LICENSE file.
