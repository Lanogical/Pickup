//
//  HereViewController.swift
//  Pickup
//
//  Created by Ben Koska on 3/5/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material

class HereViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    //MARK:- Variables
    @IBOutlet weak var selector: UIPickerView!
    
    var kidData: [[String]] = [["Ben Koska"]]
    
    var selected: String = "Standard"
    
    var currentRow = 0
    
    @IBAction func doneClicked(_ sender: Any) {
        if data.count == 0 {
            currentRow = 0
            kidData = [[]]
        }
        if selected != "Other" && kidData.isEmpty == false{
            var newGroup: [String] = []
            for x in kidData[currentRow] {
                APIRequests.logKid(x, callback: {})
                newGroup.append(x)
            }
            
             let groupString = newGroup.joined(separator: ", ")
            
            let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showGroup") as! displayGroupsViewController
            cont.groupText = groupString
            present(cont, animated: true, completion: nil)

        }else{
            let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customGroup")
            present(cont, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if APIRequests.isConnectedToNetwork() {
            
        }else{
            let alertController = UIAlertController(title: "Error: No Internet Connection", message:
                "No Internet Connection: Please Connect to Internet and retry", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hereController")
                self.present(cont, animated: false, completion: nil)
            }))
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        if data.count == 0 {
            selected = "Other"
        }else{
            selected = data[0]
        }
        let token = UserDefaults.standard.string(forKey: LocalData.tokenKey)
        APIRequests.getGroups(token: token!) { (output) in
            
            self.kidData = []
            self.data = []
            var currentKidData: [String] = []
            for group in output {
                self.data.append(group["name"] as! String)
                currentKidData = (group["kids"] as! String).components(separatedBy: ", ")
                self.kidData.append(currentKidData)
            }
            self.data.append("Other")
            self.selector.reloadAllComponents()
        }
        
        selected = "Standard"
        
        self.selector.dataSource = self
        self.selector.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = data[row]
        currentRow = row
    }
}
