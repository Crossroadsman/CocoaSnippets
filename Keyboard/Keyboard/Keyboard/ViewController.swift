//
//  ViewController.swift
//  Keyboard
//
//  Created by Alex Koumparos on 31/01/17.
//  Copyright © 2017 Koumparos Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        // register self as an observer to detect when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        // register self as an observer to detect when keyboard disappears
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }
    
    /**
     The observer does not automatically release itself from memory when the view disappears. We therefore need to tell the view to remove the observers when the view unloads.
    */
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    /**
     It is important to note that the process of opening a keyboard can cause multiple calls to `UIKeyboardWillShowNotification` if custom keyboards or quicktype are active. E.g., Swype calls once with a height of 0, then 216, then 256.
     
    At each point the notification has a beginning size and an ending size (Apple's documentation is ambiguous about what is beginning and ending, seemingly suggesting a spatial beginning and ending, but it actually appears that this is a temporal beginning and ending).
     
     For example, on an iPhone 6+ in portrait: disengaging predictions (the quicktype suggestions) while the keyboard is visible will send a notification with a beginning of height 271 and an ending with height 226
     
     Another example: bringing the keyboard onscreen (default keyboard) has a beginning and ending of 271.
     */
    func keyboardWillShow(_ sender: NSNotification) {
        print("show")
        let userInfo = sender.userInfo!
        
        // get the keyboard size beginning*
        let beginSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        print("begin size: \(beginSize)")
        
        // get the keyboard size end*
        let endSize: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        print("end size: \(endSize)")
        
        
        // Provided we are using the apple keyboard
        // when the keyboard comes into view from being offscreen
        // begin and end are the same (begin and end only differ when the keyboard is already in view and changes its appearance, e.g., by showing/hiding quicktype)
        //
        // We need both branches (begin == end / else)
        // because in the case where the two are equal, we want the offset to be the begin/endsize
        // but
        // when they are different, we want the offset to be the delta between begin and end
        if beginSize.height == endSize.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.view.frame.origin.y -= beginSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.15, animations: {self.view.frame.origin.y += beginSize.height - endSize.height})
        }
    }
    
    func keyboardWillHide(_ sender: NSNotification) {
        print("hide")
        let userInfo = sender.userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        
        self.view.frame.origin.y += keyboardSize.height
        
        //
        
    }


}

