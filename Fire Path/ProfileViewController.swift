//
//  ProfileViewController.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/9/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var tweets = [Tweet]?()
    var user = User!()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = User.currentUser
        }
        
        navigationItem.title = "Profile"
    
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "downloadAndShowUserTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        profileImageView.setImageWithURL(NSURL(string: (user.profileImageUrlString)!))
        nameLabel.text = user.name
        screenNameLabel.text = user.screenname
        tweetsCountLabel.text = "\(user.tweetCount!)"
        followersCountLabel.text = "\(user.followersCount!)"
        followingCountLabel.text = "\(user.followingCount!)"
        
        downloadAndShowUserTweets()
    }
    
    func downloadAndShowUserTweets() {
        let userId = user.id!
        TwitterClient.sharedInstance.userTimelineWithParams(nil, userId: userId) { (tweets, error) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! HomeTweetCell
        cell.tweet = tweets?[indexPath.row]
        
        return cell
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
