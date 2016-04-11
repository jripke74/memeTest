//
//  MemeTableViewController.swift
//  TestMeme
//
//  Created by Jeff Ripke on 4/1/16.
//  Copyright © 2016 JeffRipke. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var memeTableView: UITableView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        memeTableView.delegate = self
        memeTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        memeTableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath)
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.image
        cell.textLabel?.text = meme.topMemeTextField
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
}