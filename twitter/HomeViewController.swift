//
//  HomeViewController.swift
//  twitter
//
//  Created by Bryan Pon on 9/28/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class HomeViewController: TimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.current?.logout()
    }
    
    override func tableViewFetchData(success: [Tweet] -> (), failure: NSError -> ()) {
        TwitterClient.instance.homeTimeline(nil, success: success, failure: failure)
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
