//
//  ViewController.swift
//  Notes-CoreData
//
//  Created by Rustem Supayev on 20/11/2019.
//  Copyright © 2019 Rustem Supayev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var items: [NSManagedObject] = []
    let cellId = "cellId"
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch let err as NSError {
            print("Failed to fetch", err)
        }
    }
    
    @objc func addItem(_sender: AnyObject) {
        let alertController = UIAlertController(title: "Add", message: "please add item", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alertController.textFields?.first, let itemToAdd = textField.text else { return }
            self.save(itemToAdd)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func save(_ itemName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        item.setValue(itemName, forKey: "itemName")
        
        do {
            try managedContext.save()
            items.append(item)
        } catch let err as NSError {
            print("failed to save", err)
        }
        
    }
    
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
                self.fetchRequest
                self.tableView.reloadData()
            } catch {
                print("Failed to delete")
            }
            
        }
    }
    
}

