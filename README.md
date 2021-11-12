# Read Me

![Super Simple RSS on macOS](https://blog-geofcrowl-static-images.s3.amazonaws.com/2021-11-11-super-simple-rss/super-simple-rss-macos-12.png)

A really simple RSS reader for iOS and macOS.

### Installation
There are no binary builds available at the moment. You'll need to download or clone the source and build it in Xcode.

### Goals

#### Fast and lightweight RSS reader with a minimal but system native look and feel.
- A great RSS reader should be left in the background with minimal system resources used.
- Super Simple RSS should feel like the missing iOS and macOS RSS reader.

#### Shared code between iOS, iPad and macOS.
The AppKit version of Super Simple RSS, while it's the most feature complete, will be deprecated and all work will go into making a great catalyst app. The further future goal is to use SwiftUI across all devices. 

### Dependencies
Currently all dependencies are managed with Swift Package Manager through Xcode. There are two necessary dependencies. The future goal is to look into writing our own code to replace these dependencies.

- [FeedKit](https://github.com/nmdias/FeedKit) is used to parse and read feeds.
- [SwiftSoup](https://github.com/scinfu/SwiftSoup) is used to find feeds from a site's HTML.

### OS Support
This app is written fully with SwiftUI. As a result, only recent OS versions are supported.
- The macOS version supports macOS 12+
- The iOS version supports iOS 15.0+

### Feature list
[ ] Add a feed by URL
[x] Add a URL and find a feed
[ ] Update a feed URL
[ ] When multiple feeds are available, present a choice
[x] Have a collection of all posts
[ ] Allow the user to create custom collections

### Contributing
- Fork it
- Create your feature branch: `git checkout -b feature/fooBar`
- Commit your changes: `git commit -am 'Add some fooBar'`
- Push to the branch: `git push origin feature/fooBar`
- Create a new Pull Request
