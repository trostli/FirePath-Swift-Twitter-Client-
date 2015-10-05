//
//  TweetsViewController.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/2/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets = [Tweet]?()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "downloadAndShowTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        downloadAndShowTweets()
    }

    func downloadAndShowTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! HomeTweetCell
        cell.delegate = self
        cell.tweet = tweets?[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tweetCellDelegate(tweetCell: HomeTweetCell, didTapRetweet tweet: Tweet) {
        if tweet.isRetweeted == false {
            TwitterClient.sharedInstance.retweetMessageWithParams(nil, tweetId: tweet.id!) { (tweet, error) -> () in
                if error != nil {
                    print("error: \(error)")
                } else {
                    print("retweet count:` \(tweet?.retweetedCount)")
                    tweetCell.tweet = tweet
                }
            }
        }
    }
    
    func tweetCellDelegate(tweetCell: HomeTweetCell, didTapFavorite tweet: Tweet) {
        if tweet.isFavorited == false {
            let parameters = ["id": tweet.id!]
            TwitterClient.sharedInstance.favoriteMessageWithParams(parameters) { (tweet, error) -> () in
                if error != nil {
                    print("error: \(error)")
                } else {
                    print("favorite count: \(tweet?.favoritesCount)")
                    tweetCell.tweet = tweet
                }
            }
        }
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        User.currentUser?.logout()
    }

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is HomeTweetCell {
            let cell = sender as! HomeTweetCell
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet =  cell.tweet
        }
    }


}
