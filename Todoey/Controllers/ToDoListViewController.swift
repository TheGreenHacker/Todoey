//
//  ViewController.swift
//  Todoey
//
//  Created by Jack Li on 8/21/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDos = [ToDo]()
    var category : Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view.
        self.title = category.text!
        
        retrieveAll()
    }

    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let toDo = toDos[indexPath.row]
        
        cell.textLabel?.text = toDo.text
        cell.accessoryType = toDo.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let toDo = toDos[indexPath.row]
        /*
        delete(text: toDo.text!)
        toDos.remove(at: indexPath.row)
        */
        //update(text: toDo.text!, done: !toDo.done)
        update(text: toDo.text!)
        tableView.reloadData()
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter item"
        })
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self.create(text: text)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(addItemAction)
        present(alert, animated: true)
    }
    
    // MARK: - CRUD operations
    func create(text: String) {
        //let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: context)!
        
        //let toDo = ToDo(entity: entity, insertInto: context)
        let toDo = ToDo(context: context)
        
        toDo.text = text
        toDo.done = false
        toDo.category = category
        /*
        toDo.setValue(text, forKey: "text")
        toDo.setValue(false, forKey: "done")
        toDo.setValue(category, forKey: "category")
        */
        
        toDos.append(toDo)
        
        saveChanges()
    }
    
    func retrieve(request: NSFetchRequest<ToDo>) -> [ToDo] {
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            print("Could not retrieve data: \(error)")
            return []
        }
    }
    
    func update(text: String) {
        let request:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        request.predicate = NSPredicate(format: "category.text == %@ AND text == %@", category.text!, text)
        
        let result = retrieve(request: request)
        if !result.isEmpty {
            //category.removeFromToDos(result.first!)
            result.first!.done = !result.first!.done
            //result.first!.setValue(done, forKey: "done")
            //result.first!.setValue(nil, forKey: "category")
            //category.addToToDos(result.first!) , done : Bool
            saveChanges()
        }
    }
    
    func delete(text : String) {
        let request:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        request.predicate = NSPredicate(format: "category.text == %@ AND text == %@", category.text!, text)
        
        let result = retrieve(request: request)
        if !result.isEmpty {
            context.delete(result.first!)
            //category.removeFromToDos(result.first!)
            saveChanges()
        }
    }
    
    // MARK: - Save any changes to database
    func saveChanges() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save changes: \(error)")
        }
    }
    
    // MARK: - Get all ToDo's for this category
    func retrieveAll() {
        let request:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        request.predicate = NSPredicate.init(format: "category.text == %@", category.text!)
        toDos = retrieve(request: request)
    }
}

// MARK: - SearchBar Delegate Methods
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        request.predicate = NSPredicate(format: "category.text == %@ AND text CONTAINS[c] %@", category.text!, searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        
        toDos = retrieve(request: request)
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        retrieveAll()
        tableView.reloadData()
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }

}
