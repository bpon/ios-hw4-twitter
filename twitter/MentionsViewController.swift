//
//  MentionsViewController.swift
//  twitter
//
//  Created by Bryan Pon on 10/6/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class MentionsViewController: TimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableViewFetchData(success: [Tweet] -> (), failure: NSError -> ()) {
        TwitterClient.instance.mentionsTimeline(nil, success: success, failure: failure)
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
