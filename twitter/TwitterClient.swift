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
        GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let tweets = (response as [NSDictionary]).map{Tweet(dictionary: $0)}
                success(tweets)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                failure(error)
            }
        )
    }
}
