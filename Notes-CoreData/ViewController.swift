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
    
    // MARK: - Properties

    var items: [NSManagedObject] = []
    let cellId = "cellId"
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
    
  
    // MARK: - Handlers
    
    func setupUI() {
       
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        
    }
    
    @objc func addItem(_sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add Note", message: "Insert Your Note Here:", preferredStyle: .alert)
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
    
    func save(_ itemName: String) {
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
    
    
}

