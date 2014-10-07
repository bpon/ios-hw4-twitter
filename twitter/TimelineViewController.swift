//
//  TimelineViewController.swift
//  twitter
//
//  Created by Bryan Pon on 10/6/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refresh: UIRefreshControl!
    
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refresh, atIndex: 0)
        
        loadData() {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "details") {
            let selectedPath = tableView.indexPathForSelectedRow()!
            (segue.destinationViewController as TweetViewController).tweet = tweets[selectedPath.row]
            tableView.deselectRowAtIndexPath(selectedPath, animated: false)
        } else if (segue.identifier == "profile") {
            let photoButton = sender as UIButton
            let c = (segue.destinationViewController as UINavigationController).viewControllers[0] as ProfileViewController
            c.user = tweets[photoButton.tag].user
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        let photoRequest = NSURLRequest(URL: NSURL(string: tweet.user.profileImageUrl))
        cell.userPhotoView.setImageWithURLRequest(photoRequest, placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            cell.userPhotoView.image = image
            }, failure: nil)
        cell.userPhotoButton.tag = indexPath.row
        cell.nameLabel.text = tweet.user.name
        cell.screenNameLabel.text = "@\(tweet.user.screenName)"
        cell.tweetLabel.text = tweet.text
        cell.tweetedAtLabel.text = tweet.createdAtRelative
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func onRefresh() {
        loadData() {
            self.refresh.endRefreshing()
        }
    }
    
    func tableViewFetchData(success: [Tweet] -> (), failure: NSError -> ()) {
        fatalError("Don't know how to fetch data")
    }
    
    private func loadData(onComplete: () -> ()) {
        tableViewFetchData({tweets in
            self.tweets = tweets
            self.tableView.reloadData()
            onComplete()
        }, failure: {error in
                println(error)
        })
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
