//
//  SearchDownTableView.swift
//  Pickup
//
//  Created by Ben Koska on 3/25/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit

class SearchDownTableView: UITableView {
    var data: [String] = ["Joe", "Doe"]
    
    var normalData: [String] = []
    
    var superViewController: CreateGroup = CreateGroup()
    
    var textField: SearchDownTextField = SearchDownTextField()
    
    let reuseIdentifier = "searchDownCell"
    
    override func awakeFromNib() {
        
        normalData = data
        
        self.delegate = self
        self.dataSource = self
    }
    
    func updateData(new: String) {
        let oldData = normalData
        data = []
        for x in oldData {
            if x.lowercased().contains(new.lowercased()) {
                data.append(x)
            }
        }
        reloadData()
    }
}

extension SearchDownTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.alpha = 0
        textField.text = data[indexPath.row]
        superViewController.updateNow()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension SearchDownTableView: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SearchDownTableViewCell
        
        let row = data[indexPath.row]
        
        cell?.title.text = row
        
        return cell!
    }
}
