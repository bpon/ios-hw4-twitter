//
//  TwitterClient.swift
//  twitter
//
//  Created by Bryan Pon on 9/27/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

struct Twitter {

    static let consumerKey = "7IrMe7wkYsNULx23e3cCdrN0D"
    static let consumerSecret = "l4n7UUfZNkr5eVuaFg2Yvq6VppML7KskFh57VziBYHhr5vYLsV"
    static let baseUrl = "https://api.twitter.com"
}

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())!
    
    class var instance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: NSURL(string: Twitter.baseUrl), consumerKey: Twitter.consumerKey, consumerSecret: Twitter.consumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (User?, NSError?) -> ()) {
        loginCompletion = completion
        //Get request token and authorize
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuthToken!) -> Void in
                let authzUrl = NSURL(string: "\(Twitter.baseUrl)/oauth/authorize?oauth_token=\(requestToken.token)")
                println("Authorization URL: \(authzUrl)")
                UIApplication.sharedApplication().openURL(authzUrl)
            },
            failure: { (error: NSError!) -> Void in
                self.loginCompletion(user: nil, error: error)
            }
        )
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query),
            success: { (accessToken: BDBOAuthToken!) -> Void in
                self.requestSerializer.saveAccessToken(accessToken)
                self.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        let user = User(dictionary: response as NSDictionary)
                        User.current = user
                        self.loginCompletion(user: user, error: nil)
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        self.loginCompletion(user: nil, error: error)
                    }
                )
            },
            failure: { (error: NSError!) -> Void in
                self.loginCompletion(user: nil, error: error)
            }
        )
    }
    
    func homeTimeline(params: NSDictionary?, success: [Tweet] -> (), failure: NSError -> ()) {
        getTimeline("statuses/home_timeline.json", params: nil, success: success, failure: failure)
    }
    
    func userTimeline(screenName: String, params: NSDictionary?, success: [Tweet] -> (), failure: NSError -> ()) {
        getTimeline("statuses/user_timeline.json?screen_name=\(screenName)", params: nil, success: success, failure: failure)
    }
    
    private func getTimeline(path: String, params: NSDictionary?, success: [Tweet] -> (), failure: NSError -> ()) {
        GET("1.1/\(path)", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("Timeline: \(response)")
                let tweets = (response as [NSDictionary]).map{Tweet(dictionary: $0)}
                success(tweets)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                failure(error)
            }
        )
    }
    
    func tweet(text: String, success: Tweet -> (), failure: NSError -> ()) {
        postTweet("statuses/update.json", params: ["status": text], success, failure)
    }
    
    func reply(text: String, tweet: Tweet, success: Tweet -> (), failure: NSError -> ()) {
        postTweet("statuses/update.json", params: ["status": text, "in_reply_to_status_id": tweet.id], success, failure)
    }
    
    func retweet(tweet: Tweet, success: Tweet -> (), failure: NSError -> ()) {
        postTweet("statuses/retweet/\(tweet.id).json", params: nil, success, failure)
    }
    
    //Saves the current favorited status of the specified tweet
    func saveFavorited(tweet: Tweet, success: Tweet -> (), failure: NSError -> ()) {
        let op = tweet.favorited ? "create" : "destroy"
        postTweet("favorites/\(op).json?id=\(tweet.id)", params: nil, success, failure)
    }
    
    private func postTweet(path: String, params: NSDictionary?, success: Tweet -> (), failure: NSError -> ()) {
        let endpoint = "1.1/\(path)"
        println("POST \(endpoint)")
        POST(endpoint, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            success(Tweet(dictionary: response as NSDictionary))
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                failure(error)
        }
    }
}

extension String {
    
    subscript(r: Range<Int>) -> String {
        let start = advance(startIndex, r.startIndex)
        let end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }
}

extension UIColor {
    
    class func colorWithHexString(s: String, a: CGFloat = 1) -> UIColor {
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        NSScanner(string: s[0...1]).scanHexInt(&r)
        NSScanner(string: s[2...3]).scanHexInt(&g)
        NSScanner(string: s[4...5]).scanHexInt(&b)
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
}
