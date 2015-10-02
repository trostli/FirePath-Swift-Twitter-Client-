//
//  TwitterClient.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/1/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

let twitterConsumerKey = "h0IWVxSRoAY1g26mG9S7seZly"
let twitterConsumerSecret = "Nnfs2QtMHOFbhPgcGuen2hoVWyBoQlacBwxHevi44LLVoXYn9k"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL:twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }

        return Static.instance
    }

}
