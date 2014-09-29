//
//  HomeViewController.swift
//  twitter
//
//  Created by Bryan Pon on 9/28/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        TwitterClient.instance.homeTimeline(nil, success: {tweets in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: {error in
            println(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        let photoRequest = NSURLRequest(URL: NSURL(string: tweet.user.profileImageUrl))
        cell.userPhotoView.setImageWithURLRequest(photoRequest, placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            cell.userPhotoView.image = image
        }, failure: nil)
        cell.nameLabel.text = tweet.user.name
        cell.screenNameLabel.text = "@\(tweet.user.screenName)"
        cell.tweetLabel.text = tweet.text
        //TODO created_at
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.current?.logout()
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
