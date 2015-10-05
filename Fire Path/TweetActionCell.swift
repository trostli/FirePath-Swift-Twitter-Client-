//
//  TweetActionCell.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/3/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

@objc protocol TweetActionCellDelegate {
    optional func tweetActionCellDelegate(userActionsCell: TweetActionCell, didTapRetweet tweet: Tweet)
    optional func tweetActionCellDelegate(userActionsCell: TweetActionCell, didTapFavorite tweet: Tweet)
}

class TweetActionCell: UITableViewCell {

    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    weak var delegate: TweetActionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapRetweetRecognizer = UITapGestureRecognizer(target: self, action: "onRetweetTap")
        retweetImageView.userInteractionEnabled = true
        retweetImageView.addGestureRecognizer(tapRetweetRecognizer)
        
        let tapFavoriteRecognizer = UITapGestureRecognizer(target: self, action: "onFavoriteTap")
        favoriteImageView.userInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(tapFavoriteRecognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onRetweetTap() {
        delegate?.tweetActionCellDelegate?(self, didTapRetweet: tweet)
    }
    
    func onFavoriteTap() {
        delegate?.tweetActionCellDelegate?(self, didTapFavorite: tweet)
    }
    
    var tweet: Tweet! {
        didSet {
            if tweet.isFavorited == true {
                favoriteImageView.image = UIImage(named: "favorite_on")
            }
            if tweet.isRetweeted == true {
                retweetImageView.image = UIImage(named: "retweet_on")
            }
        }
    }

}
