//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Taiowa Waner on 4/4/15.
//  Copyright (c) 2015 Taiowa Waner. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Vars
    
    let topPlaceholder = "TOP"
    let bottomPlaceholder = "BOTTOM"
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0,
        
    ]
    
    var memedImage: UIImage?
    var topTextFieldTapped = false
    var resetView = true
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (UIApplication.sharedApplication().delegate as AppDelegate).memes.count > 0 {
            self.showTableView()
        }
        
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        self.subscribeToKeyboardNotification()
        self.shareButton.enabled = false
        if resetView {
            self.initView()
            // Flip reset view to false
            self.resetView = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func shareTapped(sender: UIBarButtonItem) {
        self.memedImage = self.generateMemedImage()
        let controller = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
        self.presentViewController(controller, animated: true) { () -> Void in
            
        }
        controller.completionWithItemsHandler = save
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.initView()
        
        if (UIApplication.sharedApplication().delegate as AppDelegate).memes.count < 0 {
            self.showTableView()
        }
    }
    
    @IBAction func cameraTapped(sender: UIBarButtonItem) {
        self.getImage(.Camera)
    }
    
    @IBAction func albumTapped(sender: UIBarButtonItem) {
        self.getImage(.PhotoLibrary)
    }
    
    ///
    /// Gets an image from the source passed into the method.
    ///
    ///:param: source Source that image can be selected from
    func getImage(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == topPlaceholder || textField.text == bottomPlaceholder {
            textField.text = ""
        }
        // use tag on text field to not move the top view.
        topTextFieldTapped = textField.tag == 1
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.shareButton.enabled = true
            self.resetView = false
        })
    }
    
    // MARK: - UIKeyboard methods
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    Helper methods for subscriptions
    */
    
    ///
    ///Determines if the view's frame should move up when the keyboard is tapped.
    ///
    ///:param: notification Notification taht the keyboard will appear.
    func keyboardWillShow(notification: NSNotification) {
        if !topTextFieldTapped {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardFrameWillHide(notification: NSNotification) {
        if !topTextFieldTapped {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return keyboardSize.CGRectValue().height
    }

    /**
    Memed Image helper methods will go here. These will assist in generating; saving the meme.
    */
    
    // MARK: - Memed Image helpers
    
    ///
    /// Initializes the view to the default state.
    ///
    func initView(){
        self.topTextField.delegate = self
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.textAlignment = .Center
        self.topTextField.text = topPlaceholder
        self.topTextField.autocapitalizationType = .AllCharacters
        
        self.bottomTextField.delegate = self
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.textAlignment = .Center
        self.bottomTextField.text = bottomPlaceholder
        self.bottomTextField.autocapitalizationType = .AllCharacters
        self.imageView.image = nil
        self.shareButton.enabled = false
    }
    
    
    ///
    /// Hides or shows the Navbar and Toolbar based on param.
    ///:param: action to determine whether to hide or show the bars.
    func showHideBars(action: Bool) {
        navigationController?.navigationBarHidden = action
        self.toolbar.hidden = action
    }
    
    ///
    /// Generates a memed image. Hides the nav and toolbars then creates an image from the context. Makes the bars visible and returns the memed image.
    func generateMemedImage() -> UIImage {
        // Hide bars
        self.showHideBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Show bars
        self.showHideBars(false)
        return memedImage
    }
    
    
    ///
    /// Saves a new Meme struct and adds the save Meme to the Memes data source array
    func save(activityType:String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) {
        if completed {
            var meme = Meme(bottomText: self.bottomTextField.text, topText: self.topTextField.text, image: self.imageView.image!, memedImage: self.memedImage!)
            (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
            
        }
    }


    // MARK: - Navigation
    
    ///
    /// Presents the TabController
    func showTableView() {
        var nc = self.storyboard?.instantiateViewControllerWithIdentifier("MemeTabBar") as UITabBarController
        self.presentViewController(nc, animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
