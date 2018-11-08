//
//  ViewController.swift
//  Todoey
//
//  Created by Chot on 07/11/2018.
//  Copyright © 2018 Kelvin Chot. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let ITEMS_ARRAY_KEY = "itemObjectsArray"
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: ITEMS_ARRAY_KEY) as? [Item] {
            itemArray = items
        }
    }

    //MARK - Table View Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt", indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item  = itemArray[indexPath.row] 
        
        print("cellForRowAt", item.done)
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print("didSelectRowAt", indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        print("didSelectRowAt", itemArray[indexPath.row].done)
        tableView.reloadData()
//        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addNewItem(_ sender: Any) {
        
        var textField : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item()
            item.title = textField.text!
            
            self.itemArray.append(item)
//            self.defaults.set(self.itemArray, forKey: self.ITEMS_ARRAY_KEY)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        present(alert, animated: true, completion: nil)
    }
}
