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
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }


}

