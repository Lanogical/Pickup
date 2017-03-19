//
//  CustomGroupViewController.swift
//  Pickup
//
//  Created by Ben Koska on 3/14/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import TKAutoCompleteTextField
import Material

class CustomGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var firstTextField: TKAutoCompleteTextField!
    @IBOutlet var secondTextField: TKAutoCompleteTextField!
    @IBOutlet var thirdTextField: TKAutoCompleteTextField!
    @IBOutlet var fourthTextField: TKAutoCompleteTextField!
    @IBOutlet var fifthTextField: TKAutoCompleteTextField!
    @IBOutlet var sixthTextField: TKAutoCompleteTextField!
    @IBOutlet var seventhTextField: TKAutoCompleteTextField!
    
    static let shared = CustomGroupViewController()
    
    var kids = ["Ben Koska", "Tom Koska", "Luk Koska"]
    
    var current_show = 1
    
    @IBOutlet var groupName: TextField!
   
    @IBOutlet var fab: FabButton!
    
    override func viewDidAppear(_ animated: Bool) {
        if APIRequests.isConnectedToNetwork() {
            
        }else{
            let alertController = UIAlertController(title: "Error: No Internet Connection", message:
                "No Internet Connection: Please Connect to Internet and retry", preferredStyle: UIAlertControllerStyle.alert)
            //            alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: nil))
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customGroup")
                self.present(cont, animated: false, completion: nil)
            }))
            
            present(alertController, animated: true, completion: nil)
        }
        
        kids = []
        APIRequests.getKids { (kids) in
            for kid in kids {
                self.kids.append(kid["name"]!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
        self.view.backgroundColor = Theme.background
        
        kids = []
        APIRequests.getKids { (kids) in
            for kid in kids {
                self.kids.append(kid["name"]!)
            }
            
            self.firstTextField.suggestions = self.kids
            self.firstTextField.suggestionView.reloadData()
            self.secondTextField.suggestions = self.kids
            self.secondTextField.suggestionView.reloadData()
            self.thirdTextField.suggestions = self.kids
            self.thirdTextField.suggestionView.reloadData()
            self.fourthTextField.suggestions = self.kids
            self.fourthTextField.suggestionView.reloadData()
            self.fifthTextField.suggestions = self.kids
            self.fifthTextField.suggestionView.reloadData()
            self.sixthTextField.suggestions = self.kids
            self.sixthTextField.suggestionView.reloadData()
            self.seventhTextField.suggestions = self.kids
            self.seventhTextField.suggestionView.reloadData()
        }
        
        self.firstTextField.delegate = self
        self.secondTextField.delegate = self
        self.thirdTextField.delegate = self
        self.fourthTextField.delegate = self
        self.fifthTextField.delegate = self
        self.sixthTextField.delegate = self
        self.seventhTextField.delegate = self
        self.groupName.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Setup UI
    
    @IBAction func fabClicked(_ sender: Any) {
        current_show += 1
        editShown()
    }
    
    func setupUI(){
        setupText1()
        setupText2()
        setupText3()
        setupText4()
        setupText5()
        setupText6()
        setupText7()
        view.backgroundColor = Color.grey.lighten2
        fab.title = ""
        fab.image = Icon.add
        
    }
    
    func createGroup() {
        var newGroup = [String()]
        
        if (firstTextField.text?.isEmpty)! != true {newGroup.append(firstTextField.text!)}
        if (secondTextField.text?.isEmpty)! != true {newGroup.append(secondTextField.text!)}
        if (thirdTextField.text?.isEmpty)! != true {newGroup.append(thirdTextField.text!)}
        if (fourthTextField.text?.isEmpty)! != true {newGroup.append(fourthTextField.text!)}
        if (fifthTextField.text?.isEmpty)! != true {newGroup.append(fifthTextField.text!)}
        if (sixthTextField.text?.isEmpty)! != true {newGroup.append(sixthTextField.text!)}
        if (seventhTextField.text?.isEmpty)! != true {newGroup.append(seventhTextField.text!)}
        newGroup.remove(at: 0)
        let groupString = newGroup.joined(separator: ", ")
        APIRequests.createGroup(kids: groupString, name: groupName.text!)
        
        let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showGroup") as! displayGroupsViewController
        cont.groupText = groupString
        present(cont, animated: true, completion: nil)
    }
    
    func addKids() {
        var newGroup: [String] = []
        
        if (firstTextField.text?.isEmpty)! != true {
            APIRequests.logKid(firstTextField.text!, callback: {})
            newGroup.append(firstTextField.text!)
        }
        if (secondTextField.text?.isEmpty)! != true {
            APIRequests.logKid(secondTextField.text!, callback: {})
            newGroup.append(secondTextField.text!)
        }
        if (thirdTextField.text?.isEmpty)! != true {
            APIRequests.logKid(thirdTextField.text!, callback: {})
            newGroup.append(thirdTextField.text!)
        }
        if (fourthTextField.text?.isEmpty)! != true {
            APIRequests.logKid(fourthTextField.text!, callback: {})
            newGroup.append(fourthTextField.text!)
        }
        if (fifthTextField.text?.isEmpty)! != true {
            APIRequests.logKid(fifthTextField.text!, callback: {})
            newGroup.append(fifthTextField.text!)
        }
        if (sixthTextField.text?.isEmpty)! != true {
            APIRequests.logKid(sixthTextField.text!, callback: {})
            newGroup.append(sixthTextField.text!)
        }
        if (seventhTextField.text?.isEmpty)! != true {
            APIRequests.logKid(seventhTextField.text!, callback: {})
            newGroup.append(seventhTextField.text!)
        }
        
        let groupString = newGroup.joined(separator: ", ")
        
        let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showGroup") as! displayGroupsViewController
        cont.groupText = groupString
        present(cont, animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        //"HomeScreen"
        if (firstTextField.text?.isEmpty)! != true && (groupName.text?.isEmpty)!{
            addKids()
        }else if (firstTextField.text?.isEmpty)! != true && (groupName.text?.isEmpty)! == false {
            createGroup()
        }else{
            AnimatePartOne()
        }
        
    }
    
    func AnimatePartOne(){
        UIView.animate(withDuration: 0.125, animations: {
            self.firstTextField.x -= 10
        }) { (succes) in
            if succes {
                self.AnimatePartTwo()
            }
        }
    }
    
    func AnimatePartTwo(){
        UIView.animate(withDuration: 0.125) { 
            self.firstTextField.x += 10
        }
    }
    
    func editShown() {
        switch current_show {
        case 2:
            secondTextField.alpha = 1
            secondTextField.isEnabled = true
        break
            
        case 3:
            thirdTextField.alpha = 1
            thirdTextField.isEnabled = true
        break
            
        case 4:
            fourthTextField.alpha = 1
            fourthTextField.isEnabled = true
        break
            
        case 5:
            fifthTextField.alpha = 1
            fifthTextField.isEnabled = true
        break
            
        case 6:
            sixthTextField.alpha = 1
            sixthTextField.isEnabled = true
        break
            
        case 7:
            seventhTextField.alpha = 1
            seventhTextField.isEnabled = true
            fab.isEnabled = false
        break
            
        default:
            break
        }
    }
    
    func setupText1(){
        firstTextField.suggestions = kids
        firstTextField.suggestionView.width = firstTextField.width - ((firstTextField.width / 100) * 15)
    }
    
    func setupText2(){
        secondTextField.suggestions = kids
        secondTextField.alpha = 0
        secondTextField.isEnabled = false
        secondTextField.suggestionView.width = secondTextField.width - ((secondTextField.width / 100) * 15)
    }
    
    func setupText3(){
        thirdTextField.suggestions = kids
        thirdTextField.alpha = 0
        thirdTextField.isEnabled = false
        thirdTextField.suggestionView.width = thirdTextField.width - ((thirdTextField.width / 100) * 15)
    }
    
    func setupText4(){
        fourthTextField.suggestions = kids
        fourthTextField.alpha = 0
        fourthTextField.isEnabled = false
        fourthTextField.suggestionView.width = fourthTextField.width - ((fourthTextField.width / 100) * 15)
    }
    
    func setupText5(){
        fifthTextField.suggestions = kids
        fifthTextField.alpha = 0
        fifthTextField.isEnabled = false
        fifthTextField.suggestionView.width = fifthTextField.width - ((fifthTextField.width / 100) * 15)
    }

    func setupText6(){
        sixthTextField.suggestions = kids
        sixthTextField.alpha = 0
        sixthTextField.isEnabled = false
        sixthTextField.suggestionView.width = sixthTextField.width - ((sixthTextField.width / 100) * 15)
    }

    func setupText7(){
        seventhTextField.suggestions = kids
        seventhTextField.alpha = 0
        seventhTextField.isEnabled = false
        seventhTextField.suggestionView.width = seventhTextField.width - ((seventhTextField.width / 100) * 15)
    }

}
