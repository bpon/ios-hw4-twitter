//
//  Tweet.swift
//  twitter
//
//  Created by Bryan Pon on 9/28/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class Tweet: NSObject {
   
    var user: User
    var id: Int
    var text: String
    var createdAt: NSDate
    var retweets: Int
    var favorites: Int
    var retweeted: Bool
    var favorited: Bool
    
    class var jsonDateFormatter: NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = {
                let df = NSDateFormatter()
                df.dateFormat = "EEE MMM d HH:mm:ss Z y"
                return df
            }()
        }
        return Static.instance
    }
    
    class var fullDateFormatter: NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = {
                let df = NSDateFormatter()
                df.dateFormat = "M/d/YY, HH:mm"
                return df
            }()
        }
        return Static.instance
    }
    
    class var shortDateFormatter: NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = {
                let df = NSDateFormatter()
                df.dateFormat = "M/d/YY"
                return df
            }()
        }
        return Static.instance
    }
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as NSDictionary)
        id = dictionary["id"] as Int
        text = dictionary["text"] as String
        createdAt = Tweet.jsonDateFormatter.dateFromString(dictionary["created_at"] as String)!
        retweets = dictionary["retweet_count"] as Int
        favorites = dictionary["favorite_count"] as Int
        retweeted = (dictionary["retweeted"] as Bool)
        favorited = (dictionary["favorited"] as Bool)
    }
    
    var createdAtRelative: String {
        get {
            switch (0 - Int(createdAt.timeIntervalSinceNow)) {
            case let t where t < 1: return "now"
            case let t where t < 60: return "\(t)s"
            case let t where t < 3600: return "\(t / 60)m"
            case let t where t < 86400: return "\(t / 3600)h"
            case let t where t < 604800: return "\(t / 86400)d"
            default: return Tweet.shortDateFormatter.stringFromDate(createdAt)
            }
        }
    }
    
    var createdAtDetailed: String {
        get {
            return Tweet.fullDateFormatter.stringFromDate(createdAt)
        }
    }
}
