//
//  ParentHomeViewController.swift
//  Pickup
//
//  Created by Ben Koska on 3/5/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material

class ParentHomeViewController: UIViewController {

    @IBOutlet var snackBar: Snackbar!
    
    @IBOutlet var hereButton: FlatButton!
    
    @IBOutlet var settingsButton: IconButton!
    
    var snackBarText = ""
    
    var closebutton = UIButton(type: .system)
    var timer = Timer()
    func logout() {
        UserDefaults.standard.set(nil, forKey: LocalData.tokenKey)
        UserDefaults.standard.synchronize()
        let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginScreen")
        present(cont, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if APIRequests.isConnectedToNetwork() {
            
        }else{
            let alertController = UIAlertController(title: "Error: No Internet Connection", message:
                "No Internet Connection: Please Connect to Internet and retry", preferredStyle: UIAlertControllerStyle.alert)
            //            alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: nil))
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                let cont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeScreen")
                self.present(cont, animated: false, completion: nil)
            }))
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        settingsButton.image = UIImage(named: "ic_exit_to_app")?.withRenderingMode(.alwaysTemplate)
        settingsButton.tintColor = Color.grey.base
        settingsButton.backgroundColor = Color.clear
        settingsButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        if snackBarText != "" {
            snackBar.text = snackBarText
        }else{
            snackBar.alpha = 0
        }
        snackBar.rightViews = [closebutton]
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 7.5, target: self, selector: #selector(hideSnackBar), userInfo: nil, repeats: false)
    }
    
    func hideSnackBar(){
        UIView.animate(withDuration: 0.5) { 
            self.snackBar.position.y += self.snackBar.width
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
