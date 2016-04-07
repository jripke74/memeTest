//
//  MemeTableViewController.swift
//  TestMeme
//
//  Created by Jeff Ripke on 4/1/16.
//  Copyright © 2016 JeffRipke. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//        memes = applicationDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView?.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        let meme = memes[indexPath.item]
        cell.textLabel?.text = meme.topMemeTextField
        cell.imageView?.image = meme.image
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
}