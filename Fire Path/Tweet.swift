//
//  Tweet.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/1/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoritesCount: Int?
    var retweetedCount: Int?
    var isRetweeted: Bool?
    var retweetedBy: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favoritesCount = dictionary["favourites_count"] as? Int
        retweetedCount = dictionary["retweeted_count"] as? Int
        if dictionary["retweeted_status"] != nil {
            isRetweeted = true
            retweetedBy = dictionary.valueForKeyPath("retweeted_status.entities.user_mentions.name") as? String
        } else {
            isRetweeted = false
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            print(dictionary)
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}

    