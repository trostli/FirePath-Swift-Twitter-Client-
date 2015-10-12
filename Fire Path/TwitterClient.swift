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

    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL:twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }

        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func userTimelineWithParams(params: NSDictionary?, userId: Int, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json?user_id=\(userId)", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "fire-path://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func tweetMessageWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweet: nil, error: error)
        }
    }
    
    func retweetMessageWithParams(params: NSDictionary?, tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweet: nil, error: error)
        }
    }
    
    func favoriteMessageWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("response from favorite \(response)")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweet: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                print("user: \(user.name)")
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)

            })
            
            
        }) { (error: NSError!) -> Void in
            print("failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }

    }

}
