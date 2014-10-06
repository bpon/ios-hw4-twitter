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
    
    var homeViewController: UIViewController!
    
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
        
        homeViewController = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
        
        setCurrentController(homeViewController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapProfile(sender: AnyObject) {
    }
    
    @IBAction func onTapTimeline(sender: AnyObject) {
        setCurrentController(homeViewController)
    }

    @IBAction func onTapMentions(sender: AnyObject) {
    }
    
    func setCurrentController(c: UIViewController) {
        containerView.frame = UIScreen.mainScreen().bounds
        addChildViewController(c)
        c.view.frame = containerView.frame
        containerView.addSubview(c.view)
        c.didMoveToParentViewController(self)
        /*UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.center.x -= 100
        })*/
    }
    
    @IBAction func onTapContainer(sender: AnyObject) {
        println("tap")
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
