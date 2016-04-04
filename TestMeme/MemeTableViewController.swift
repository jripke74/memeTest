//
//  MemeTableViewController.swift
//  TestMeme
//
//  Created by Jeff Ripke on 4/1/16.
//  Copyright © 2016 JeffRipke. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
}