//
//  MemeDetailViewController.swift
//  TestMeme
//
//  Created by Jeff Ripke on 4/7/16.
//  Copyright © 2016 JeffRipke. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        memedImageView!.image = meme.completedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
    }
}