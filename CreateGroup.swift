//
//  CreateGroup.swift
//  Pickup
//
//  Created by Ben Koska on 3/20/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material
/// Create Group Viewcontroller
class CreateGroup: UIViewController, UITextFieldDelegate{
    
    var kids: [String] = []
    var groupArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        kidsSelectTableView.superViewController = self
        
        doneButton.isEnabled = false
        
        kidsTextField.autocorrectionType = .no
        
        APIRequests.getKids { (kids) in
            self.kidsSelectTableView.data = []
            for kid in kids {
                self.kidsSelectTableView.data.append(kid["name"]!)
            }
            self.kidsSelectTableView.reloadData()
            self.kidsSelectTableView.normalData = self.kidsSelectTableView.data
        }
        
        hideSearchDown()
        
        kidsSelectTableView.textField = kidsTextField
        
        self.kidsLabel.text = ""
        
        kidsTextField.placeholder = "Kid's name"
        
        kidsTextField.delegate = self
        
        kidsTextField.addTarget(self, action: #selector(showSearchDown), for: UIControlEvents.touchDown)
        
        kidsTextField.addTarget(self, action: #selector(updateNow), for: UIControlEvents.editingChanged)
        
        doneButton.backgroundColor = Theme.secondary.withAlphaComponent(0.55)
        doneButton.titleColor = Color.white
        
        addButton.isEnabled = false
    }
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var groupName: TextField!
    
    @IBOutlet var doneButton: FlatButton!
    
    /**
     Handles Done Button Click
     */
    
    @IBAction func doneClicked(_ sender: Any) {
        let groupString = groupArray.joined(separator: ", ")
        if groupName.text! != "" {
            APIRequests.createGroup(kids: groupString, name: groupName.text!)
            let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGroup") as! displayGroupsViewController
            cont.groupText = groupString
            present(cont, animated: true, completion: nil)
        }else{
            for kid in groupArray {
                APIRequests.logKid(kid, callback: {})
            }
            let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showGroup") as! displayGroupsViewController
            cont.groupText = groupString
            present(cont, animated: true, completion: nil)
        }
        
    }
    
    /**
     Updates the Tableview Data
    */
    
    func updateNow() {
        if kidsSelectTableView.data.contains(kidsTextField.text!) && !(kidsLabel.text!.contains(kidsTextField.text!)){
            addButton.isEnabled = true
        }else{
            addButton.isEnabled = false
        }
        kidsSelectTableView.updateData(new: kidsTextField.text!)
    }
    
    /**
     Opens the Searchable Dropdown
     */
    
    func showSearchDown() {
        kidsSelectTableView.alpha = 1
    }
    
    /**
     Closes the Searchable Dropdown
     */
    
    func hideSearchDown() {
        kidsSelectTableView.alpha = 0
    }

    /**
     Kids Name Textfield
     */
    @IBOutlet var kidsTextField: SearchDownTextField!
    /**
     List of Kids Label
     */
    @IBOutlet var kidsLabel: UILabel!
    
    @IBOutlet var kidsSelectTableView: SearchDownTableView!
    /**
     Handels Add Button Clicked
     */
    @IBAction func addClicked(_ sender: Any) {
        if kidsTextField.text! != "" {
            kidsLabel.text!.append("\(kidsTextField.text!) \n")
            groupArray.append(kidsTextField.text!)
        }
        
        kidsTextField.text = ""
        
        doneButton.isEnabled = true
        doneButton.backgroundColor = Theme.secondary.withAlphaComponent(1)
    
        kidsSelectTableView.data = kidsSelectTableView.normalData
        kidsSelectTableView.reloadData()
        
        showSearchDown()
        
        updateNow()
    }
    
    /**
     Close keyboard when you click enter
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
}
