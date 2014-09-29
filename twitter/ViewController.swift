//
//  ViewController.swift
//  twitter
//
//  Created by Bryan Pon on 9/23/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        User.login({ user in
            self.performSegueWithIdentifier("login", sender: self)
        }, failure: { error in
            println(error)
        })
    }

}

