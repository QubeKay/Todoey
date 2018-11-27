//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Chot on 21/11/2018.
//  Copyright © 2018 Kelvin Chot. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Found"

        return cell
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let category = Category()
            category.name = textField.text!
        
            self.saveData(category: category)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving cetegory! Error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
    
        categoryArray = realm.objects(Category.self)
            
        tableView.reloadData()
    }
}
