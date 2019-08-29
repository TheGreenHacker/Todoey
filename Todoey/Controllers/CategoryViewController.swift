//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jack Li on 8/28/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let request:NSFetchRequest<Category> = Category.fetchRequest()
        categories = retrieve(request: request)
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.text
        
        return cell
    }
    
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
        let category = Category(context: context)
        
        category.text = text
        categories.append(category)
        
        saveChanges()
    }
    
    func retrieve(request: NSFetchRequest<Category>) -> [Category] {
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            print("Could not retrieve data: \(error)")
            return []
        }
    }
    /*
    func update(text : String, done : Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        request.predicate = NSPredicate(format: "text = %@", text)
        
        if let result = retrieve(request: request), let toDo = result.first{
            toDo.setValue(done, forKey: "done")
            saveChanges()
        }
    }
    
    func delete(text : String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        request.predicate = NSPredicate(format: "text = %@", text)
        
        if let result = retrieve(request: request), let toDo = result.first{
            context.delete(toDo)
            saveChanges()
        }
    }
    */
    // MARK: - Save any changes to database
    func saveChanges() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save changes: \(error)")
        }
    }
    
    
    
    
    
    
}
