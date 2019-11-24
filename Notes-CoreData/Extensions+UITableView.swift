//
//  Extensions+UITableView.swift
//  Notes-CoreData
//
//  Created by Rustem Supayev on 24/11/2019.
//  Copyright © 2019 Rustem Supayev. All rights reserved.
//

import UIKit

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.value(forKeyPath: "itemName") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(self.items[indexPath.row])
            do {
                try managedContext.save()
                self.items.remove(at: indexPath.row)
                self.tableView.reloadData()
            } catch {
                print("Failed to delete.")
            }
            
        }
    }
    
}
