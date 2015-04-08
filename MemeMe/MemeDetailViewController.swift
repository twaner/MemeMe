//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Taiowa Waner on 4/4/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.meme.memedImage
        self.title = "Meme"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
