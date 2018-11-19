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
    let ITEMS_FILE_PATH = "Items.plist"
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
    }
    
    // MARK - Add New Items
    
    @IBAction func addNewItem(_ sender: Any) {
        
        var textField : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item()
            item.title = textField.text!
            
            self.itemArray.append(item)
            self.saveData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(itemArray)
            
            try data.write(to: dataFilePath!)
        } catch {
            print("Failed to save items to file! Error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Failed to load items from file! Error: \(error)")
            }
        }
    }
}
