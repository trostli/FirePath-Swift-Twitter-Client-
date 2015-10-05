//
//  ComposeTweetViewController.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/3/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var subViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var subView: UIView!
    
    
    var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        subView.layer.cornerRadius = 15
        subView.clipsToBounds = true
        
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = "@" + (User.currentUser?.screenname)!
        
        let profileImageURL = NSURL(string: (User.currentUser?.profileImageUrlString)!)
        profileImageView.setImageWithURL(profileImageURL)
        
        tweetTextView.text = "Compose your Tweet of up to 144 characters here."
        tweetTextView.textColor = UIColor.lightGrayColor()
        tweetTextView.textContainerInset = UIEdgeInsetsZero
        tweetTextView.textContainer.lineFragmentPadding = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, atIndex: 0)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let value = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        keyboardHeight = rect.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        let params = ["status": tweetTextView.text]
        TwitterClient.sharedInstance.tweetMessageWithParams(params) { (tweet, error) -> () in
            if error != nil {
                print("error: \(error)")
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func onCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Text View
    
    func dismissKeyboard() {
        tweetTextView.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if tweetTextView.textColor == UIColor.lightGrayColor() {
            tweetTextView.text = nil
            tweetTextView.textColor = UIColor.blackColor()
        }

        if keyboardHeight != nil {
            subViewCenterYConstraint.constant = keyboardHeight!/2 * -1
            view.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if tweetTextView.text.isEmpty {
            tweetTextView.text = "Compose your Tweet of up to 144 characters here."
            tweetTextView.textColor = UIColor.lightGrayColor()
        }
        
        subViewCenterYConstraint.constant = 0
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
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
