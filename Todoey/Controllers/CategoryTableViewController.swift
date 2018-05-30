//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by ravizza on 5/29/18.
//  Copyright © 2018 ravizza. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }


    // MARK: - TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        //cell.accessoryType = category.done ? .checkmark : .none
        
        return cell
    }
    // MARK: - Data Manipulations Methods
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do{
            categories = try context.fetch(request)
        }catch {
            print("Error fetching Category data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving Category\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Tableview Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      performSegue(withIdentifier: "goToItems", sender: self)
    }
    
}
