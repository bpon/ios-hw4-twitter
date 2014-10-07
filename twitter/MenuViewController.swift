//
//  MenuViewController.swift
//  twitter
//
//  Created by Bryan Pon on 10/4/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var userPhotoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet var containerTapGesture: UITapGestureRecognizer!
    
    lazy var homeViewController: UIViewController = self.getControllerByName("HomeViewController")
    lazy var profileViewController: UIViewController = {
        let nc = self.getControllerByName("ProfileViewController") as UINavigationController
        let c = nc.viewControllers[0] as ProfileViewController
        c.user = User.current
        return nc
    }()
    lazy var mentionsViewController: UIViewController = self.getControllerByName("MentionsViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = User.current!
        let photoRequest = NSURLRequest(URL: NSURL(string: user.profileImageUrl))
        userPhotoView.setImageWithURLRequest(photoRequest, placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.userPhotoView.image = image
            }, failure: nil)
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName)"
        
        setCurrentController(homeViewController, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        menuView.frame.origin.x = -menuView.frame.width
        containerView.frame = view.frame
        containerTapGesture.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapProfile(sender: AnyObject) {
        setCurrentController(profileViewController)
    }
    
    @IBAction func onTapTimeline(sender: AnyObject) {
        setCurrentController(homeViewController)
    }

    @IBAction func onTapMentions(sender: AnyObject) {
        setCurrentController(mentionsViewController)
    }
    
    func setCurrentController(c: UIViewController, animated: Bool = true) {
        if (animated) {
            hideMenu()
        }
        containerView.frame = UIScreen.mainScreen().bounds
        addChildViewController(c)
        c.view.frame = containerView.frame
        containerView.addSubview(c.view)
        c.didMoveToParentViewController(self)
    }
    
    @IBAction func onTapContainer(sender: AnyObject) {
        hideMenu()
    }

    @IBAction func onPanContainer(sender: UIPanGestureRecognizer) {
        let menuWidth = menuView.frame.width
        let translation = sender.translationInView(containerView)
        if (sender.state == UIGestureRecognizerState.Changed) {
            if (!isMenuHidden() && translation.x < 0) {
                menuView.frame.origin.x = translation.x
                containerView.frame.origin.x = translation.x + menuWidth
            } else if (isMenuHidden() && translation.x > 0) {
                menuView.frame.origin.x = translation.x - menuWidth
                containerView.frame.origin.x = translation.x
            }
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (translation.x < -menuWidth/2 || (translation.x > 0 && translation.x < menuWidth/2)) {
                hideMenu()
            } else if ((isMenuHidden() && translation.x > 0) || (!isMenuHidden() && translation.x < 0)) {
                showMenu()
            }
        }
    }
    
    private func isMenuHidden() -> Bool {
        return !containerTapGesture.enabled
    }
    
    private func hideMenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.frame.origin.x = -self.menuView.frame.width
            self.containerView.frame.origin.x = 0
        }) { (s: Bool) -> Void in
            self.containerTapGesture.enabled = false
        }
    }
    
    private func showMenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.frame.origin.x = 0
            self.containerView.frame.origin.x = self.menuView.frame.width
        }) { (s: Bool) -> Void in
            self.containerTapGesture.enabled = true
        }
    }
    
    private func getControllerByName(name: String) -> UIViewController {
        return storyboard?.instantiateViewControllerWithIdentifier(name) as UIViewController
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
