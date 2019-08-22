//
//  ViewController.swift
//  Todoey
//
//  Created by Jack Li on 8/21/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    let key = "ToDos"
    var toDos = [String]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        toDos = defaults.object(forKey: key) as? [String] ?? [String]()
    }

    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //let cell = tableView.cellForRow(at: indexPath)
        cell.textLabel?.text = toDos[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            print("Selected cell containing: \(toDos[indexPath.row])")
            tableView.deselectRow(at: indexPath, animated: true)
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter item"
        })
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            let toDo = alert.textFields![0].text!
            
            self.toDos.append(toDo)
            self.defaults.set(self.toDos, forKey: self.key)
            self.tableView.reloadData()
        }
        
        alert.addAction(addItemAction)
        present(alert, animated: true)
    }
}

