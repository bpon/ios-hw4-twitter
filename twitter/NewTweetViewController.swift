//
//  NewTweetViewController.swift
//  twitter
//
//  Created by Bryan Pon on 9/29/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var userPhotoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetField: UITextView!
    
    var originalTweet: Tweet? //For replies
    
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
        tweetField.text = originalTweet == nil ? "" : "@\(originalTweet!.user.screenName) "
        tweetField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTouchCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTouchTweet(sender: AnyObject) {
        let onSuccess = {(tweet: Tweet) -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let onFailure = {(error: NSError) -> () in
            println(error)
        }
        if (originalTweet != nil) {
            TwitterClient.instance.reply(tweetField.text, tweet: originalTweet!, success: onSuccess, failure: onFailure)
        } else {
            TwitterClient.instance.tweet(tweetField.text, success: onSuccess, failure: onFailure)
        }
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
