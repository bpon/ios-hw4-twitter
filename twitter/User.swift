//
//  User.swift
//  twitter
//
//  Created by Bryan Pon on 9/28/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUser"
let userDidLoginNotification = "userDidLogin"
let userDidLogoutNotification = "userDidLogout"

class User: NSObject {
   
    var dictionary: NSDictionary
    var name: String
    var screenName: String
    var profileImageUrl: String
    var tweetCount: Int
    var followingCount: Int
    var followerCount: Int
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as String
        screenName = dictionary["screen_name"] as String
        profileImageUrl = dictionary["profile_image_url"] as String
        tweetCount = dictionary["statuses_count"] as Int
        followingCount = dictionary["friends_count"] as Int
        followerCount = dictionary["followers_count"] as Int
    }
    
    class func login(success: User -> (), failure: NSError -> ()) {
        TwitterClient.instance.loginWithCompletion() { (user: User?, error: NSError?) in
            if (user != nil) {
                success(user!)
            } else {
                failure(error!)
            }
        }
    }
    
    func logout() {
        User.current = nil
        TwitterClient.instance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: self)
    }
    
    class var current: User? {
        get {
            if (_currentUser == nil) {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if (data != nil) {
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let data = user != nil ? NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil) : nil
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
