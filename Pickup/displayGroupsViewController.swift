//
//  displayGroupsViewController.swift
//  Pickup
//
//  Created by Ben Koska on 3/19/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material

class displayGroupsViewController: UIViewController {
    
    var groupText: String = ""
    
    var groupArray: [String] = []
    
    var groupTextWN = ""
    
    @IBOutlet var groupLabel: UILabel!
    @IBOutlet var doneButton: FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
        doneButton.backgroundColor = Theme.secondary
        doneButton.titleColor = Color.white
        
        self.view.backgroundColor = Theme.background
        
        groupArray = groupText.components(separatedBy: ", ")
        
        for x in groupArray {
            groupTextWN.append("\(x) \n \n")
        }
        
        groupLabel.text = groupTextWN
        groupLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        groupLabel.numberOfLines = 14
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
