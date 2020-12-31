# Read Me

![Super Simple RSS on macOS](https://blog-geofcrowl-static-images.s3.us-east-1.amazonaws.com/2020-12-31-super-simple-rss/super-simple-rss-macos-11.png)

A really simple RSS reader for iOS and macOS.

### Goals

#### Fast and lightweight RSS reader with a minimal but system native look and feel.
- A great RSS reader should be left in the background with minimal system resources used.
- Super Simple RSS should feel like the missing iOS and macOS RSS reader.

#### Minimal to no dependencies
- We should be: familiar with all our code, not require large code packages to do the basic tasks we need, not beholden to other groups.

#### Shared code between iOS, iPad and macOS.
The AppKit version of Super Simple RSS, while it's the most feature complete, will be deprecated and all work will go into making a great catalyst app. The further future goal is to use SwiftUI across all devices. 

### Dependencies
Currently all dependencies are managed with Swift Package Manager through Xcode. There are two necessary dependencies. The future goal is to look into writing our own code to replace these dependencies.

- [FeedKit](https://github.com/nmdias/FeedKit) is used to parse and read feeds.
- [SwiftSoup](https://github.com/scinfu/SwiftSoup) is used to find feeds from a site's HTML.

### OS Support
- The AppKit version of Super Simple RSS (deprecated) supports 10.13.0+
- The iOS/Catalyst version supports iOS 14.0 and macOS 11.0 and newer.
