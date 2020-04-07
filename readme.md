### Demonstrates a SQLite3 leak

Everything's in `app_delegate.rb`

The autorelease_pool is in there just to show clearly there's a leak (prevents memory buildup in the loop)

Tested on iOS 13.3.1 and 13.4, RM 7.2/Xcode 11.3.1 and RM 7.4/Xcode 11.4.
