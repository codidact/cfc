# cf
Simple library for interacting with the Cloudflare API.

## Install
Clone the repository. That's it!

## Usage
This library is intended to be very lightweight, to help with usage in quick but effective scripts. Scripts that use
this library can be added to `scripts/` and run from there&mdash;it's *possible* for them to go anywhere, of course,
but relative `require`s are easier from a proximate directory.

You can use the library either by instantiating `Cloudflare::API` and using that class to send API requests directly,
or, for simpler tasks, you can use pre-provided objects in `lib/objects/`, which represent a data type from the
Cloudflare API and may provide methods to perform common or simple tasks on those types. See
`lib/scripts/clear_cache.rb` for an example of how this may be done using `Cloudflare::Zone` objects.

## Contributing
As with all Codidact projects, contributions are welcome and must adhere to the
[Codidact Code of Conduct](https://meta.codidact.com/policy/code-of-conduct). Please create an issue to discuss any
major changes you propose to make, or if you think your changes may not be accepted for any reason&mdash;we'd always
rather discuss something unnecessarily than have to reject someone's hard work.

## License
This project is licensed under the terms of the MIT license, which may be found in the LICENSE file.
