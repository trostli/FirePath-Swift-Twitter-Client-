//
//  HomeTweetCell.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/2/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func tweetCellDelegate(tweetCell: HomeTweetCell, didTapRetweet tweet: Tweet)
    optional func tweetCellDelegate(tweetCell: HomeTweetCell, didTapFavorite tweet: Tweet)
}

class HomeTweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: DXTimestampLabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            
            if let user = tweet.user {
                nameLabel.text = user.name
                screenNameLabel.text = "@" + (tweet.user?.screenname)!
                profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrlString)!))
            }
            if let text = tweet.text {
                tweetLabel.text = text
            }
            timeLabel.timestamp = tweet.createdAt
            
            if tweet.isRetweeted == true {
                retweetImageView.image = UIImage(named: "retweet_on")
            }
            if tweet.isFavorited == true {
                favoriteImageView.image = UIImage(named: "favorite_on")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        layoutMargins = UIEdgeInsetsZero
        
        if let retweetImageView = retweetImageView {
            let tapRetweetRecognizer = UITapGestureRecognizer(target: self, action: "onRetweetTap")
            retweetImageView.userInteractionEnabled = true
            retweetImageView.addGestureRecognizer(tapRetweetRecognizer)
            
            let tapFavoriteRecognizer = UITapGestureRecognizer(target: self, action: "onFavoriteTap")
            favoriteImageView.userInteractionEnabled = true
            favoriteImageView.addGestureRecognizer(tapFavoriteRecognizer)
        }
    }
    
    func onRetweetTap() {
        delegate?.tweetCellDelegate?(self, didTapRetweet: tweet)
    }
    
    func onFavoriteTap() {
        delegate?.tweetCellDelegate?(self, didTapFavorite: tweet)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
