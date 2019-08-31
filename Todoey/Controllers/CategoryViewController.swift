//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jack Li on 8/28/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var categories: Results<Category>!
    override var cellIdentifier: String {
        get {
            return "CategoryCell"
        }
        set {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        retrieveAll()
    }
    
    // MARK - Swipe delete function
    override func swipeDelete(in row: Int) {
        self.delete(category: categories[row])
    }
    
    // MARK - set cell's properties
    override func editCell(in row: Int, cell: UITableViewCell) {
        let category = categories[row]
        cell.textLabel?.text = category.text
        // Assign cell corresponding to this category to a random color the first time it is created
        cell.backgroundColor = category.hexString != nil ? UIColor(hexString: category.hexString!) : RandomFlatColor()
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        update(category: category, hexString: (cell.backgroundColor?.hexValue())!)
    }
    
    // MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToToDos", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToToDos", let destination = segue.destination as? ToDoListViewController, let row = tableView.indexPathForSelectedRow?.row {
            destination.category = categories[row]
        }
        else {
            print("something went wrong")
        }
    }
    
    // MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter category"
        })
        
        let action = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self.create(text: text)
                //self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - CRUD operations
    func create(text: String) {
        let category = Category(text: text)
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch let error as NSError {
            print("Could not create category: \(error)")
        }
        retrieveAll()
    }
    
    func retrieveAll() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func update(category: Category, hexString: String) {
        do {
            try realm.write {
                category.hexString = hexString
            }
        } catch let error as NSError {
            print("Could not update category: \(error)")
        }
    }
    
    func delete(category: Category) {
        do {
            try realm.write {
                for toDo in category.toDos { // delete all the ToDo's for this category in database
                    realm.delete(toDo)
                }
                realm.delete(category)
            }
        } catch let error as NSError {
            print("Could not delete category: \(error)")
        }
    }
}
