//
//  TweetViewController.swift
//  twitter
//
//  Created by Bryan Pon on 9/29/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var userPhotoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var retweetsTextLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoritesTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let photoRequest = NSURLRequest(URL: NSURL(string: tweet.user.profileImageUrl))
        userPhotoView.setImageWithURLRequest(photoRequest, placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.userPhotoView.image = image
        }, failure: nil)
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName)"
        tweetLabel.text = tweet.text
        createdAtLabel.text = tweet.createdAtDetailed
        reloadRetweetViews()
        reloadFavoriteViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "reply") {
            let destinationController = (segue.destinationViewController as UINavigationController).viewControllers[0] as NewTweetViewController
            destinationController.originalTweet = tweet
        }
    }
    
    @IBAction func onTouchRetweet(sender: AnyObject) {
        let wasRetweeted = tweet.retweeted
        setRetweeted(true)
        TwitterClient.instance.retweet(tweet, success: {t in
            self.setRetweeted(t.retweeted)
        }, failure: {e in
            self.setRetweeted(wasRetweeted)
            println(e)
        })
    }
    
    @IBAction func onTouchFavorite(sender: AnyObject) {
        let wasFavorited = tweet.favorited
        //Change favorited status immediately, then revert on error
        setFavorited(!tweet.favorited)
        TwitterClient.instance.saveFavorited(tweet, success: {t in
            self.setFavorited(t.favorited)
        }, failure: {e in
            self.setFavorited(wasFavorited)
            println(e)
        })
    }
    
    func setRetweeted(retweeted: Bool) {
        if (tweet.retweeted && !retweeted) {
            tweet.retweets -= 1
        } else if (!tweet.retweeted && retweeted) {
            tweet.retweets += 1
        }
        tweet.retweeted = retweeted
        reloadRetweetViews()
    }
    
    func reloadRetweetViews() {
        retweetsLabel.text = "\(tweet.retweets)"
        retweetsTextLabel.text = tweet.retweets == 1 ? "RETWEET" : "RETWEETS"
        retweetButton.setImage(UIImage(named: tweet.retweeted ? "retweet-on" : "retweet"), forState: nil)
    }
    
    func setFavorited(favorited: Bool) {
        if (tweet.favorited && !favorited) {
            tweet.favorites -= 1
        } else if (!tweet.favorited && favorited) {
            tweet.favorites += 1
        }
        tweet.favorited = favorited
        reloadFavoriteViews()
    }
    
    func reloadFavoriteViews() {
        favoritesLabel.text = "\(tweet.favorites)"
        favoritesTextLabel.text = tweet.favorites == 1 ? "FAVORITE" : "FAVORITES"
        favoriteButton.setImage(UIImage(named: tweet.favorited ? "favorite-on" : "favorite"), forState: nil)
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
