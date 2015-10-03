//
//  HomeTweetCell.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/2/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class HomeTweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@" + (tweet.user?.screenname)!
            tweetLabel.text = tweet.text
            profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!))
            timeLabel.text = tweet.createdAtString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
