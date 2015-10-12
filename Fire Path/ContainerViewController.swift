//
//  ContainerViewController.swift
//  Fire Path
//
//  Created by Daniel Trostli on 10/12/15.
//  Copyright © 2015 Trostli. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuWidthConstraint.constant = 0
        self.view.setNeedsLayout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeMenu(){
        self.view.setNeedsLayout()
        self.menuWidthConstraint.constant = 0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func openMenu() {
        self.view.setNeedsLayout()
        self.menuWidthConstraint.constant = 222
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
//            self.view.setNeedsLayout()
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            let velocity = sender.velocityInView(sender.view)
            
            if velocity.x > 0.0 {
                openMenu()
            } else {
                closeMenu()
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
        }

    }
    
    @IBAction func onTimelineButton(sender: UIButton) {
        let tvc = self.childViewControllers[0] as! UITabBarController
        tvc.selectedIndex = 0
        closeMenu()
    }

    @IBAction func onProfileButton(sender: UIButton) {
        let tvc = self.childViewControllers[0] as! UITabBarController
        tvc.selectedIndex = 1
        closeMenu()
    }
    
    @IBAction func onMentionsButton(sender: UIButton) {
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
