//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Jack Li on 8/30/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    var cellIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    // MARK - to be invoked within closure in func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation)
    func swipeDelete(in row: Int) {
        
    }
    
    // MARK - set cell's properties
    func editCell(in row: Int, cell: UITableViewCell) {
        
    }
    
    // MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        editCell(in: indexPath.row, cell: cell)
        
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //action.fulfill(with: .delete)
            self.swipeDelete(in: indexPath.row)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "TrashIcon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
