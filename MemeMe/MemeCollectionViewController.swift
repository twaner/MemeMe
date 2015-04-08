//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Taiowa Waner on 4/4/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

let reuseIdentifier = "cell"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {
    
    var memes: [Meme]!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
        if self.memes.count > 0 {
            self.collectionView?.reloadData()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            }
    
    @IBAction func addTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CollectionSegue" {
            let vc = segue.destinationViewController as MemeDetailViewController
            vc.meme = self.meme
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.backgroundColor = UIColor.greenColor()
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.meme = memes[indexPath.row]
        self.performSegueWithIdentifier("CollectionSegue", sender: self)
    }
}
