//
//  CreateGroup.swift
//  Pickup
//
//  Created by Ben Koska on 3/20/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit

class CreateGroup: UIViewController, UITextFieldDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kidsTextField.delegate = self
    }

    @IBOutlet var kidsTextField: UITextField!
    @IBOutlet var kidsLabel: UILabel!
    
    @IBAction func addClicked(_ sender: Any) {
        kidsLabel.text!.append("\(kidsTextField.text!) \n")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
}
