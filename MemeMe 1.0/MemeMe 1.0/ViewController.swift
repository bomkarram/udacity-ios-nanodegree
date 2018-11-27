//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Abdulrahman Alamoudi on 11/24/18.
//  Copyright © 2018 Abdulrahman Alamoudi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var isTopTextFieldFirstTimeClicked = false  // a flag to track user editing input; only needed 1st time
    var isBottomTextFieldFirstTimeClicked = false   // a flag to track user editing input; only needed 1st time
    var keyboardHeight: CGFloat!    // this variabe really isn't needed but it must to have to solve a problem with shifting the view upward/downeard *** to keep same size shifting ***
    
    enum myTextField: Int {
        case top=0, bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMemeText(textField: topTextField, text: "TOP")
        setMemeText(textField: bottomTextField, text: "BOTTOM")

        topTextField.delegate = self
        bottomTextField.delegate = self
        
        shareButton.isEnabled = false
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        shareButton.isEnabled = false
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case myTextField.top.rawValue:
            if !isTopTextFieldFirstTimeClicked {
                isTopTextFieldFirstTimeClicked = true
                textField.text = ""
            }
        case myTextField.bottom.rawValue:
            if !isBottomTextFieldFirstTimeClicked {
                isBottomTextFieldFirstTimeClicked = true
                textField.text = ""
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    func subscribeToKeyboardNotifications() {
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // only shift the keyboard upward in case of bottomTextField
        if self.bottomTextField.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardHeight = view.frame.origin.y
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        // only shift the keyboard downward in case of bottomTextField
        if self.bottomTextField.isEditing {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func pickAnImage(_ whichButton: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch whichButton.title {
        case "Camera":
            imagePicker.sourceType = .camera
        case "Album":
            imagePicker.sourceType = .photoLibrary
        default:
            break
        }
        present(imagePicker, animated: true, completion: nil)
    }

    // change text attributes
    func setMemeText(textField: UITextField, text: String) {
        let memeTextAttr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -4.0,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!
        ]
        textField.defaultTextAttributes = memeTextAttr
        textField.textAlignment = .center
        textField.text = text
    }
    
    @IBAction func save(_ sender: Any) {
        
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {
             (activity, success, items, error) in
            if success {
                Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: image)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // prepare view for taking screenshut
        view.backgroundColor = UIColor.black
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // undo view changes
        view.backgroundColor = UIColor.white
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false

        return memedImage
    }
}
struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}
