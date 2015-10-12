//
//  TweetDetailViewController.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/3/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class TweetDetailViewController: UITableViewController, TweetActionCellDelegate {

    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! HomeTweetCell
            cell.tweet = tweet
            cell.isDetailTweetView = true
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("statCell", forIndexPath: indexPath) as! TweetStatCell
            cell.tweet = tweet
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("actionCell", forIndexPath: indexPath) as! TweetActionCell
            cell.tweet = tweet
            cell.delegate = self
            return cell
        }
    }
    
    func reloadStatAndActionCell(tweet: Tweet, tweetActionCell: TweetActionCell) {
        tweetActionCell.tweet = tweet
        let statusCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? TweetStatCell
        statusCell!.tweet = tweet
    }

    func tweetActionCellDelegate(tweetActionCell: TweetActionCell, didTapRetweet tweet: Tweet) {
        if tweet.isRetweeted == false {
            TwitterClient.sharedInstance.retweetMessageWithParams(nil, tweetId: tweet.id!) { (tweet, error) -> () in
                if error != nil {
                    print("error: \(error)")
                } else {
                    self.reloadStatAndActionCell(tweet!, tweetActionCell: tweetActionCell)
                }
            }
        }
    }
    
    func tweetActionCellDelegate(tweetActionCell: TweetActionCell, didTapFavorite tweet: Tweet) {
        if tweet.isFavorited == false {
            let parameters = ["id": tweet.id!]
            TwitterClient.sharedInstance.favoriteMessageWithParams(parameters) { (tweet, error) -> () in
                if error != nil {
                    print("error: \(error)")
                } else {
                    self.reloadStatAndActionCell(tweet!, tweetActionCell: tweetActionCell)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
