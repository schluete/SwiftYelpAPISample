#!/usr/bin/env swift -F Rome

import OMGHTTPURLRQ
import TDOAuth

let kConsumerKey = "";
let kConsumerSecret = "";
let kToken = "";
let kTokenSecret = "";

if kConsumerKey == "" {
    print("Please edit your access token before running the script!")
    exit(1)
}

func requestFor(path path: String, params: [String: String]?) -> NSURLRequest {
  let kAPIHost = "api.yelp.com"
  return TDOAuth.URLRequestForPath(path,
    GETParameters: params,
    scheme: "https",
    host: kAPIHost,
    consumerKey: kConsumerKey,
    consumerSecret: kConsumerSecret,
    accessToken: kToken,
    tokenSecret: kTokenSecret)
}

func searchRequestFor(term term: String, location: String) -> NSURLRequest {
  let kSearchPath = "/v2/search/"
  let kSearchLimit =  "3"

  return requestFor(path: kSearchPath, params: [
    "term": term,
    "location": location,
    "limit": kSearchLimit
  ])
}

func businessInfoRequestFor(businessId businessId: String) -> NSURLRequest {
  let kBusinessPath = "/v2/business/"
  return requestFor(path: kBusinessPath + businessId, params: nil)
}

func executeRequest(request: NSURLRequest, completion: ([String:AnyObject]?, error: NSError?) -> ()) {
  NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
    if let data = data,
      let response = (response as? NSHTTPURLResponse) where response.statusCode == 200
    {
      do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
        completion(json, error: nil)
      } catch _ {
        completion(nil, error: error)
      }
    } else {
      completion(nil, error: error)
    }
  }.resume()
}

func queryTopBusinessInfoFor(term term: String, location: String, completion: ([NSString: AnyObject]?) -> ()) {
  let searchRequest = searchRequestFor(term: term, location: location)
  executeRequest(searchRequest) { (json, error) -> () in
    guard let businesses = json?["businesses"] as? [[String: AnyObject]] where businesses.count > 0 else {
      completion(nil)
      return
    }
    guard let businessId = businesses[0]["id"] as? String else {
      completion(nil)
      return
    }

    let infoRequest = businessInfoRequestFor(businessId: businessId)
    executeRequest(infoRequest, completion: { (json, error) in
      completion(json)
    })
  }
}

let lockGroup = dispatch_group_create()
dispatch_group_enter(lockGroup)

queryTopBusinessInfoFor(term: "Dinner", location: "München, Deutschland") { (topBusiness) in
  if let topBusiness = topBusiness {
    print("Top business info: \n\(topBusiness)");
  } else {
    print("No business was found or an error occured");
  }
  dispatch_group_leave(lockGroup)
}

dispatch_group_wait(lockGroup, DISPATCH_TIME_FOREVER)
