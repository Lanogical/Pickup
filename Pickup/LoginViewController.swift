//
//  LoginViewController.swift
//  Pickup
//
//  Created by Ben Koska on 3/5/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameField: TextField!
    @IBOutlet var passwordField: TextField!
    @IBOutlet var loginButton: FlatButton!
    
    @IBOutlet var errorField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        errorField.text = ""
        
        if let token = UserDefaults.standard.string(forKey: LocalData.tokenKey) {
            APIRequests.loginWithToken(token, callback: { (succes,rank) in
                if succes {
                    if rank == "parent" {
                        let contrer = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hereController")
                        self.present(contrer, animated: false, completion: nil)
                    }else if rank == "admin" {
                        let cont = UIStoryboard(name: "Teachers", bundle: nil).instantiateInitialViewController()
                        self.present(cont!, animated: false, completion: nil)
                    }
                }
            })
        }
    }

    @IBAction func loginClicked(_ sender: Any) {
        APIRequests.login(usernameField.text!, pwd: passwordField.text!) { (dict) in
            if dict["succes"] as! Bool == true {
                UserDefaults.standard.set(dict["token"], forKey: LocalData.tokenKey)
                UserDefaults.standard.synchronize()

                if dict["rank"] as! String == "parent" {
                    let contrer = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hereController")
                    self.present(contrer, animated: true, completion: nil)
                }else if dict["rank"] as! String == "admin" {
                    let cont = UIStoryboard(name: "Teachers", bundle: nil).instantiateInitialViewController()
                    self.present(cont!, animated: true, completion: nil)
                }
            }else{
             self.errorField.text = "Incorrect Email/Password"
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        setupBackground()
        setupUsernameField()
        setupLoginButton()
        setupPasswordButton()
        setupColors()
    }
    
    func setupPasswordButton() {

    }
    
    func setupColors() {
        self.view.backgroundColor = Theme.background
        self.loginButton.backgroundColor = Theme.secondary
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if APIRequests.isConnectedToNetwork() {
            
        }else{
            let alertController = UIAlertController(title: "Error: No Internet Connection", message:
                "No Internet Connection: Please Connect to Internet and retry", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginScreen")
                self.present(cont, animated: false, completion: nil)
            }))
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func setupLoginButton(){
        loginButton.title = "Login"
        loginButton.titleColor = Color.white
        loginButton.pulseColor = Color.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        APIRequests.login(usernameField.text!, pwd: passwordField.text!) { (dict) in
            if dict["succes"] as! Bool == true {
                UserDefaults.standard.set(dict["token"], forKey: LocalData.tokenKey)
                UserDefaults.standard.synchronize()
                
                if dict["rank"] as! String == "parent" {
                    let contrer = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hereController")
                    self.present(contrer, animated: true, completion: nil)
                }else if dict["rank"] as! String == "admin" {
                    let cont = UIStoryboard(name: "Teachers", bundle: nil).instantiateInitialViewController()
                    self.present(cont!, animated: true, completion: nil)
                }
                
            }else{
                self.errorField.text = "Incorrect Email/Password"
            }
        }
        return true
    }
    
    func setupBackground() {
        //passwordField
        passwordField.keyboardType = .default
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
    }
    
    func setupUsernameField(){
        usernameField.keyboardType = .emailAddress
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
