//
//  ViewController.swift
//  TestMeme
//
//  Created by Jeff Ripke on 3/18/16.
//  Copyright © 2016 JeffRipke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topMemeTextField: UITextField!
    @IBOutlet weak var bottomMemeTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textFields() {
        if let textFieldFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 34) {
            let memeTextFieldAttributes = [NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: textFieldFont, NSStrokeWidthAttributeName: 2.0]
            topMemeTextField.defaultTextAttributes = memeTextFieldAttributes
            bottomMemeTextField.defaultTextAttributes = memeTextFieldAttributes
        } else {
            print("Font issue")
        }
        topMemeTextField.text = "TOP"
        bottomMemeTextField.text = "BOTTOM"
        topMemeTextField.textAlignment = .Center
        bottomMemeTextField.textAlignment = .Center
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func save(memedImage: UIImage) {
        guard let topTextField = topMemeTextField.text else { fatalError("Top text field is nil") }
        guard let bottomTextField = bottomMemeTextField.text else { fatalError("Bottom text field is nil") }
        let meme = Meme(topMemeTextField: topTextField, bottomMemeTextField: bottomTextField, image: memedImage, completedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        print(UIGraphicsBeginImageContext(self.view.frame.size))
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func shareTapped(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(image)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        shareTapped(generateMemedImage())
    }
    
}