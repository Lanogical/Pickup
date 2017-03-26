//
//  TeacherTableView.swift
//  Pickup
//
//  Created by Ben Koska on 3/15/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material

class TeacherTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Data model: These strings will be the data for the table view cells
    var kids: [String] = []
    
    var calledKids: [IndexPath] = []
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "kidCell"
    
    var timer = Timer()
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: TableView!
    
    override func viewDidAppear(_ animated: Bool) {
        if APIRequests.isConnectedToNetwork() {
            
        }else{
            let alertController = UIAlertController(title: "Error: No Internet Connection", message:
                "No Internet Connection: Please Connect to Internet and retry", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                let cont = UIStoryboard(name: "Teachers", bundle: nil).instantiateInitialViewController()
                self.present(cont!, animated: false, completion: nil)
            }))
                
            present(alertController, animated: true, completion: nil)
        }

    }
    
    func updateFrame() {
        self.kids = []
        APIRequests.pickedup { (kids) in
            for kid in kids {
                self.kids.append(kid["name"]! as! String)
                print(kid["token"] as! String)
            }
            self.kids = APIRequests.removeDuplicates(array: self.kids)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateFrame), userInfo: nil, repeats: true)
        
        updateFrame()
        
        
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let called = UITableViewRowAction(style: .default, title: "Called") { (action, index) in
            //Called
            self.calledKids.append(index)
            self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
        }
        called.backgroundColor = Theme.secondary
        if tableView.cellForRow(at: indexPath)?.backgroundColor == Theme.secondary {
            let pickedup = UITableViewRowAction(style: .destructive, title: "✓") { (action, index) in
                //Pickedup
                APIRequests.removeKids(name: self.kids[indexPath.row])
                self.kids.remove(at: index.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            pickedup.backgroundColor = Color.blueGrey.base
            return [pickedup]
        }
        return [called]
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.kids.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        for x in calledKids {
            if x == indexPath {
                cell.backgroundColor = Theme.secondary
            }
        }
        cell.textLabel?.text = self.kids[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
