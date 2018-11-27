//
//  ViewController.swift
//  Todoey
//
//  Created by Chot on 07/11/2018.
//  Copyright © 2018 Kelvin Chot. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Table View Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cellForRowAt", indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item  = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items in " + (selectedCategory?.name ?? "Category" )
        }
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
//                realm.delete(item)
            }
            } catch {
                print("Error saving done status: \(error)")
            }
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItem(_ sender: Any) {
        
        var textField : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Could not save item: \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
        tableView.reloadData()
    }
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItemsWith(filter: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadItems()
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            loadItemsWith(filter: searchBar.text!)
        }
    }
    
    func loadItemsWith(filter: String) {
//        print("filter: \(filter)")
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", filter).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
