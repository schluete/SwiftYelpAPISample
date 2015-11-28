# Yelp API v2 Swift code sample

## Overview

This program demonstrates the capability of the Yelp API version 2.0 in two ways:

- It uses the Search API to query for businesses by a search term and location.
- It uses the Business API to query additional information about the top result from the search query.

## Steps to run

- This sample uses CocoaPods for managing dependencies. If you haven't used CocoaPods, [install it following the instructions from the CocoaPods website](https://guides.cocoapods.org/using/getting-started.html#getting-started).

- Install the [cocoapods-rome Gem](https://github.com/neonichu/Rome) to use CocoaPods outside of Xcode:
```
$ gem install cocoapods-rome
```

- Set up the dependencies by running:
```
$ pod install
```

- Edit your developer keys at the top of topBusiness.swift. These keys can be found in the section "[Manage your Keys](http://www.yelp.com/developers/manage_api_keys)" on Yelp's developer site.

- Then execute the script:
```
$ ./topBusiness.swift
```

## More details

Please refer to [API documentation](http://www.yelp.com/developers/documentation)
for more details on the requests you can make on our API.
