//
//  Tweet.swift
//  twitter
//
//  Created by Bryan Pon on 9/28/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class Tweet: NSObject {
   
    var user: User!
    var text: String!
    var createdAt: NSDate!
    
    class var dateFormatter: NSDateFormatter {
        struct Static {
            static let instance: NSDateFormatter = {
                let df = NSDateFormatter()
                df.dateFormat = "EEE MMM d HH:mm:ss Z y"
                return df
            }()
        }
        return Static.instance
    }
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        let createdAtString = dictionary["created_at"] as? String
        createdAt = createdAtString != nil ? Tweet.dateFormatter.dateFromString(createdAtString!) : nil
    }
}
