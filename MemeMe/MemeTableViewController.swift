//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Taiowa Waner on 4/4/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: - Vars
    
    var memes: [Meme]!
    var meme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
        
        if self.memes.count > 0 {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        let meme = self.memes[indexPath.row]
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.image
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.meme = self.memes[indexPath.row]
        self.performSegueWithIdentifier("MemeDetail", sender: self)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MemeDetail" {
            let vc = segue.destinationViewController as MemeDetailViewController
            vc.meme = self.meme
        }

    }


}
