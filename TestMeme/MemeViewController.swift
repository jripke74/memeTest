//
//  ViewController.swift
//  TestMeme
//
//  Created by Jeff Ripke on 3/18/16.
//  Copyright © 2016 JeffRipke. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var topMemeTextField: UITextField!
    @IBOutlet weak var bottomMemeTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    let imagePicker = UIImagePickerController()
    var imageForMeme: UIImage?
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        textFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageForMeme = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickerView.image = imageForMeme
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFields() {
        if let textFieldFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) {
            let memeTextFieldAttributes = [NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: textFieldFont, NSStrokeWidthAttributeName: -4.0]
            topMemeTextField.defaultTextAttributes = memeTextFieldAttributes
            bottomMemeTextField.defaultTextAttributes = memeTextFieldAttributes
        } else {
            print("Font issue")
        }
        topMemeTextField.text = "TOP"
        bottomMemeTextField.text = "BOTTOM"
        topMemeTextField.textAlignment = .Center
        bottomMemeTextField.textAlignment = .Center
        topMemeTextField.clearsOnBeginEditing = true
        bottomMemeTextField.clearsOnBeginEditing = true
        topMemeTextField.backgroundColor = UIColor.clearColor()
        bottomMemeTextField.backgroundColor = UIColor.clearColor()
        bottomMemeTextField.delegate = self
        topMemeTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomMemeTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomMemeTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func save(memedImage: UIImage) {
        guard let topTextField = topMemeTextField.text else { fatalError("Top text field is nil") }
        guard let bottomTextField = bottomMemeTextField.text else { fatalError("Bottom text field is nil") }
        let meme = Meme(topMemeTextField: topTextField, bottomMemeTextField: bottomTextField, image: memedImage, completedImage: memedImage)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        topNavigationBar.hidden = true
        bottomToolBar.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        topNavigationBar.hidden = false
        bottomToolBar.hidden = false
        return memedImage
    }
    
    func shareTapped(image: UIImage?) {
        if imageForMeme == nil {
            let noPictureAlert = UIAlertController(title: "No Image Sellected", message: "Would you please pick a picture!!!", preferredStyle: .ActionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            noPictureAlert.addAction(cancelAction)
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let takePictureAction: UIAlertAction = UIAlertAction(title: "Take picture", style: .Default) { action -> Void in
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                }
                noPictureAlert.addAction(takePictureAction)
            }
            let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            noPictureAlert.addAction(choosePictureAction)
            presentViewController(noPictureAlert, animated: true, completion: nil)
        } else {
            let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: [])
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    self.save(image!)
                }
            }
            presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    func reset() {
        bottomToolBar.hidden = false
        imagePickerView.image = nil
    }
    
    @IBAction func resetButton(sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        shareTapped(generateMemedImage())
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}