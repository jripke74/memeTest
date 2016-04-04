//
//  MemeCollectionViewController.swift
//  TestMeme
//
//  Created by Jeff Ripke on 4/1/16.
//  Copyright © 2016 JeffRipke. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        //memes = applicationDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collecionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collecionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.topMemeLabel.text = meme.topMemeTextField
        cell.bottomMemeLabel.text = meme.bottomMemeTextField
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        detailController.meme = memes[indexPath.row]
    }
}