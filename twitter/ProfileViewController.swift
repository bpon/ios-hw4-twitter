//
//  ProfileViewController.swift
//  twitter
//
//  Created by Bryan Pon on 10/6/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class ProfileViewController: TimelineViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userPhotoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsTextLabel: UILabel!
    @IBOutlet weak var followersTextLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = user == User.current ? "Me" : "@\(user.screenName)"
        
        headerView.backgroundColor = user.profileBackgroundColor
        let photoRequest = NSURLRequest(URL: NSURL(string: user.profileImageUrl))
        userPhotoView.setImageWithURLRequest(photoRequest, placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.userPhotoView.image = image
        }, failure: nil)
        nameLabel.text = user.name
        nameLabel.textColor = user.profileTextColor
        screenNameLabel.text = "@\(user.screenName)"
        screenNameLabel.textColor = user.profileTextColor
        tweetsLabel.text = "\(user.tweetCount)"
        followingLabel.text = "\(user.followingCount)"
        followersLabel.text = "\(user.followerCount)"
        tweetsTextLabel.text = user.tweetCount == 1 ? "TWEET" : "TWEETS"
        followersTextLabel.text = user.followerCount == 1 ? "FOLLOWER" : "FOLLOWERS"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableViewFetchData(success: [Tweet] -> (), failure: NSError -> ()) {
        TwitterClient.instance.userTimeline(user.screenName, params: nil, success: success, failure: failure)
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
