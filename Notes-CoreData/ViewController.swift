//
//  ViewController.swift
//  Notes-CoreData
//
//  Created by Rustem Supayev on 20/11/2019.
//  Copyright © 2019 Rustem Supayev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var items: [String] = []
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = .red
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func addItem(_sender: AnyObject) {
        let alertController = UIAlertController(title: "Add a new note", message: "Please fill up the text box bellow", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alertController.textFields?.first, let itemsToAdd = textField.text else { return }
            self.items.append(itemsToAdd)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    
}

