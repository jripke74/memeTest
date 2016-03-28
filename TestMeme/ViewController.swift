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
    let keyboardControl = KeyboardControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        textFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardControl.subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardControl.unsubscribeFromKeyboardNotifications()
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
    
    func save() -> Meme {
        let meme = Meme(topMemeTextField: topMemeTextField.text!, bottomMemeTextField: bottomMemeTextField.text!, image: imagePickerView.image!)
        return meme
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        print(UIGraphicsBeginImageContext(self.view.frame.size))
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
}