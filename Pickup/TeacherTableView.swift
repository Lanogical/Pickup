//
//  TeacherTableView.swift
//  Pickup
//
//  Created by Ben Koska on 3/15/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material

class TeacherTableViewController: UITableViewController {
    
    struct ParentSection {
        var sectionName: String!
        var kids: [String]!
    }
    
    var calledKids: [IndexPath] = []
    
    var kidsOfParent: [String] = []
    
    var data: [ParentSection] = []
    
    var timer = Timer()
    
    var kidsToProcces: [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
        
        APIRequests.pickedup { (pickedup) in
            self.kidsToProcces = pickedup
            self.proccesKids()
            print(self.data)
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func preccesKidsOfParent(_ kids: [String], token: String) {
        guard kids != [] else { return }
        guard token != "" else { return }
        guard token != "about: blank" else { return }
        
        var kidos = kids
        
        kidos = APIRequests.removeDuplicates(array: kids)
        
        data.append(ParentSection(sectionName: token, kids: kidos))
        
    }
    
    func proccesKids() {
        
        data = []
        
        var currentToken = "about: blank"
        
        for kid in kidsToProcces {
            if currentToken == "about: blank" || currentToken != kid["token"]! as! String {
                preccesKidsOfParent(kidsOfParent, token: currentToken)
                kidsOfParent = []
                currentToken = kid["token"]! as! String
            }
            
            kidsOfParent.append(kid["name"]! as! String)
        }
        
        preccesKidsOfParent(kidsOfParent, token: currentToken)
        kidsOfParent = []
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateFrame), userInfo: nil, repeats: true)

    }
    
    func updateFrame() {
        APIRequests.pickedup { (pickedup) in
            self.kidsToProcces = pickedup
            self.proccesKids()
            print(self.data)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let called = UITableViewRowAction(style: .default, title: "Called") { (action, index) in
            //Called
            self.calledKids.append(index)
            self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
        }
        
        called.backgroundColor = Theme.secondary
        
        if tableView.cellForRow(at: indexPath)?.backgroundColor == Theme.secondary {
            let pickedup = UITableViewRowAction(style: .destructive, title: "✓") { (action, index) in
                //Pickedup
//                APIRequests.removeKids(name: self.data[indexPath.row])
//                self.kids.remove(at: index.row)
                APIRequests.removeKids(name: (tableView.cellForRow(at: indexPath)?.textLabel?.text!)!)
//                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                var stuf = 0
                for x in self.calledKids {
                    if x == index {
                        self.calledKids.remove(at: stuf)
                    }
                    stuf += 1
                }
                
                self.data[index.section].kids.remove(at: index.row)
                
                self.tableView.deleteRows(at: [index], with: .automatic)
                self.tableView.reloadData()
            }
            pickedup.backgroundColor = Color.blueGrey.base
            return [pickedup]
        }
        return [called]
    }
    
    func updateSectionsTitlesFunc() {
        var x = 0
        for kid in data {
            print(kid.sectionName)
            APIRequests.getNameForToken(kid.sectionName, args: x, callback: { (myLittleName, args) in
                self.data[args].sectionName = myLittleName
                self.tableView.reloadData()
            })
            x += 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherViewCell") as UITableViewCell!
        
        for x in calledKids {
            if x == indexPath {
                cell?.backgroundColor = Theme.secondary
            }
        }
        
        cell?.textLabel?.text = data[indexPath.section].kids[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].kids.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].sectionName
    }
}
