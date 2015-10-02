//
//  ViewController.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/1/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "fire-path://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
            
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
                UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

