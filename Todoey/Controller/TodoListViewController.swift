//
//  ViewController.swift
//  Todoey
//
//  Created by Chot on 07/11/2018.
//  Copyright © 2018 Kelvin Chot. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let ITEMS_ARRAY_KEY = "itemObjectsArray"
    let ITEMS_FILE_PATH = "Items.plist"
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Table View Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cellForRowAt", indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item  = itemArray[indexPath.row] 
        
//        print("cellForRowAt", item.done)
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        itemArray[indexPath.row].setValue("Imaginative Fucks", forKey: "title")
        saveData()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItem(_ sender: Any) {
        
        var textField : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            
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
            try context.save()
        } catch {
            print("Error saving context! Error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        
        let categoryPredicate = NSPredicate(format: "parentCategory.category MATCHES %@", selectedCategory!.category!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[categoryPredicate, additionalPredicate])
            
        } else { 
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching request from CoreData context: \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItemsWith(filter: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            loadItemsWith(filter: searchBar.text!)
        }
    }
    
    func loadItemsWith(filter: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", filter)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
}
