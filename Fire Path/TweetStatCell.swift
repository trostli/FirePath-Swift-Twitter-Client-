//
//  TweetStatCell.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/3/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class TweetStatCell: UITableViewCell {

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            if let retweetedCount = tweet.retweetedCount {
                retweetCountLabel.text = "\(retweetedCount)"
            }
            if let favoritesCount = tweet.favoritesCount {
                favoritesCountLabel.text = "\(favoritesCount)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
