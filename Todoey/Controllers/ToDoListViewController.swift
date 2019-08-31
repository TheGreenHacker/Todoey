//
//  ViewController.swift
//  Todoey
//
//  Created by Jack Li on 8/21/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController{
    var category : Category!
    var toDos : Results<ToDo>!
    override var cellIdentifier: String {
        get {
            return "ToDoItemCell"
        }
        set {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view.
        self.title = category.text
        
        retrieveAll()
    }
    
    // MARK - Swipe delete function
    override func swipeDelete(in row: Int) {
        delete(toDo: toDos[row])
    }
    
    // MARK - set cell's properties
    override func editCell(in row: Int, cell: UITableViewCell) {
        let toDo = toDos[row]
        
        cell.textLabel?.text = toDo.text
        cell.accessoryType = toDo.done ? .checkmark : .none
    }

    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        delete(text: toDo.text!)
        toDos.remove(at: indexPath.row)
        */
        //update(text: toDo.text!, done: !toDo.done)
        update(toDo: toDos[indexPath.row])
        //delete(toDo: toDos[indexPath.row])
        tableView.reloadData()
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter item"
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
        do {
            try realm.write {
                let toDo = ToDo(text: text)
                category.toDos.append(toDo) // associate new ToDo with current category
                realm.add(toDo)
            }
        } catch let error as NSError {
            print("Could not create ToDo: \(error)")
        }
        retrieveAll() // update tableview for creation of new cell
    }
    
    //  Get all ToDo's for this category and update the UI
    func retrieveAll() {
        toDos = realm.objects(ToDo.self).filter(NSPredicate(format: "ANY category.text == %@", category.text))
        tableView.reloadData()
    }
    
    // Query database based on specific predicate
    func retrieve(by predicate: NSPredicate) -> Results<ToDo> {
        return realm.objects(ToDo.self).filter(predicate)
    }
    
    func update(toDo: ToDo) {
        do {
            try realm.write {
                toDo.done = !toDo.done
            }
        } catch let error as NSError {
            print("Could not update ToDo: \(error)")
        }
    }
    
    func delete(toDo: ToDo) {
        do {
            try realm.write {
                realm.delete(toDo)
            }
        } catch let error as NSError {
            print("Could not delete ToDo: \(error)")
        }
    }
}

// MARK: - SearchBar Delegate Methods
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    // Fetch and display all ToDo objects in a category that contains the text in the pop up search bar, sorted by the ToDo object's date in order of most recent
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDos = realm.objects(ToDo.self).filter(NSPredicate(format: "ANY category.text == %@ AND text CONTAINS[c] %@", category.text, searchBar.text!)).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        retrieveAll()
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)  // exit out of the search bar
    }

}
